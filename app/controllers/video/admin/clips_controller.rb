# encoding: utf-8
class Video::Admin::ClipsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  include Video::Controller::Accesses

  layout :select_layout

  def pre_dispatch
    return redirect_to :action => 'index' if params[:reset]

    @ranking_state = case params[:rank]
                     when 'weekly', 'monthly', 'total'
                       "#{params[:rank]}_ranking"
                     when 'overall'
                       "overall"
                     else
                       "list"
                     end

    @limit = 10
    @admin_is = Core.user.has_auth?(:manager)
    view_count_mode
  end


  def index
    init_action
    @cols_count = 5
    @row_count  = 2

    # do action
    @items = send(@ranking_state)
    _index @items
  end


  def show
    init_action
    @item = Video::Clip.new.public.find(params[:id])
    _show @item
  end

  def new
    init_action
    @item = Video::Clip.new({
      :state      => 'closed',
    })
  end

  def create
    init_action
    @item = Video::Clip.new(params[:item])
    @item.skip_upload

    _create @item do
      @item.skip_reduce_size if @admin_is
      @item.delay.convert_to_flv(@item) if @item.convert_state == 'queue'
    end
  end

  def update
    init_action
    @item = Video::Clip.new.public.find(params[:id])
    @item.initiarize_settings([@maximum_file_size, @maximum_frame_size])
    @item.stay_attributes
    @item.attributes = params[:item]
    @item.skip_upload

    _update @item
  end

  def destroy
    init_action
    @item = Video::Clip.new.public.find(params[:id])
    _destroy @item
  end

  def preview
    init_action
    @item = Video::Clip.new.public.find(params[:id])
  end

  def negate
    init_action
    return error_auth unless @admin_is

    @item = Video::Clip.new.find(params[:id])
    @item.stay_attributes

    _negated_at = nil
    _negator_id  = nil
    unless @item.negated_at
      _negated_at = Core.now
      _negator_id = Core.user.id
    end
    @item.attributes = {:negated_at => _negated_at, :negator_id => _negator_id }

    @item.skip_upload
    _negate @item
  end


  def download
    #    item = Video::Clip.new.readable
    item = Video::Clip.new.public
    item.and :id, params[:id]
    return error_auth unless @file = item.find(:first)

    if params[:thumb]
      thumbnail_path = @file.is_sound? ? @file.sound_thumbnail_path(params[:thumb]) : @file.thumbnail_path(params[:thumb])
      #send_file thumbnail_path, :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'
      filename = thumbnail_path
      headers['X-Sendfile'] = filename
      render :nothing => true
    else
      if params[:content]
        #TODO:after convert file
        _filename = @file.name.gsub(/\.[a-z0-9]{2,}$/i, '.flv')
        #send_file @file.upload_path, :type => @file.mime_type, :filename => @file.name
        send_file @file.upload_path, :type => @file.mime_type, :filename => _filename
      else
        #send_file @file.upload_path, :type => @file.mime_type, :filename => @file.name
        # 再生回数＋貼り付け？サイト内？を保存
        log_access
        #redirect_to @file.upload_uri
        filename = @file.upload_path
        headers['X-Sendfile'] = filename
        render :nothing => true
      end
      #redirect_to "/_common/test/jwplayer/video2.flv?start=#{params[:start]}"
    end
  end

protected
  #default list
  def list
    @category = nil
    if params[:cate] && !params[:cate].blank? && params[:cate].to_s != '0'
      if cate = Video::Category.find(params[:cate])
        @category = cate
      end
    end

    item = Video::Clip.new.public
    # condition
    item.category_is(@category) if @category
    item.and :creator_group_id, params[:group] if params[:group]
    item.and :published_year,   params[:year]  if params[:year]
    item.and :published_month,  params[:month] if params[:month]

    # search
    if params[:search]
      item.and :state, params[:s_status] if !params[:s_status].blank?
      item.and params[:s_column], "LIKE", "%#{params[:s_keyword]}%" if !params[:s_column].blank? && !params[:s_keyword].strip.blank?
    end


    #item.page  params[:page], params[:limit]
    item.page  params[:page], @limit
    #item.order params[:sort], 'published_at DESC'
    item.order params[:sort], 'updated_at DESC'
    items = item.find(:all)
    #_index items
    return items
  end

  # 週間ランキング
  def weekly_ranking
    #所属公開の動画も含まれる
    _clip_tb   = Video::Clip.table_name
    _access_tb = Video::DailyAccess.table_name

    limit = @cols_count * @row_count
    item  = Video::Clip.new.public
    item.page params[:page], limit

    item.join "LEFT JOIN #{_access_tb} ON #{_clip_tb}.id = #{_access_tb}.item_id"
    item.and Condition.new do |c|
      c.or "#{_access_tb}.accessed_at", "IS", nil
      c.or "#{_access_tb}.accessed_at",  '>=', @a_week_ago
    end
    items = item.find(:all,
            :select => "#{_clip_tb}.*, MAX(#{_access_tb}.accessed_at) AS latest_access, SUM(#{_access_tb}.count) AS weekly_count",
            :group => "#{_clip_tb}.id",
            :order => "weekly_count DESC, #{_clip_tb}.updated_at DESC")
    return items
  end

  # 月間(30日)ランキング
  def monthly_ranking
    #所属公開の動画も含まれる
    _clip_tb   = Video::Clip.table_name
    _access_tb = Video::DailyAccess.table_name

    limit = @cols_count * @row_count
    item  = Video::Clip.new.public
    item.page params[:page], limit

    item.join "LEFT JOIN #{_access_tb} ON #{_clip_tb}.id = #{_access_tb}.item_id"
    item.and Condition.new do |c|
      c.or "#{_access_tb}.accessed_at", "IS", nil
      c.or "#{_access_tb}.accessed_at",  '>=', @a_month_ago
    end
    items = item.find(:all,
            :select => "#{_clip_tb}.*, MAX(#{_access_tb}.accessed_at) AS latest_access, SUM(#{_access_tb}.count) AS monthly_count",
            :group => "#{_clip_tb}.id",
            :order => "monthly_count DESC, #{_clip_tb}.updated_at DESC")
    return items
  end




  #累計ランキング
  def total_ranking
    #TODO:未使用
    #所属公開の動画も含まれる
    _clip_tb   = Video::Clip.table_name
    _access_tb = Video::DailyAccess.table_name

    limit = @cols_count * @row_count
    item  = Video::Clip.new.public
    item.page params[:page], limit

    item.join "LEFT JOIN #{_access_tb} ON #{_clip_tb}.id = #{_access_tb}.item_id"
    items = item.find(:all,
            :select => "#{_clip_tb}.*, MAX(#{_access_tb}.accessed_at) AS latest_access, SUM(#{_access_tb}.count) AS total_count",
            :group => "#{_clip_tb}.id",
            :order => "total_count DESC, #{_clip_tb}.updated_at DESC")
    return items

#    単純なview_countの降順
#    limit = @cols_count * @row_count
#    item = Video::Clip.new.public
#    item.page params[:page], limit
#    items = item.find(:all, :order => 'view_count DESC, updated_at DESC')
#    return items
  end


  #総合
  def overall
    @row_count = 2
    #週間ランキング
    @w_clips = weekly_ranking
    #月間ランキング
    @m_clips = monthly_ranking

    #新着動画
    latest = Video::Clip.new.public
    latest.page  1, 5
    latest.order params[:sort], 'updated_at DESC'
    items = latest.find(:all)
    return items
  end



  def select_layout
    layout = "admin/video/video"
    case params[:action].to_sym
      when :preview
        layout = "admin/video/preview"
    end

#    case params[:action].to_sym
#    when :new, :edit, :answer, :forward, :close, :create, :update, :resend
#      layout = "admin/gw/mail_form"
#    when :show, :move
#      unless params[:new_window].blank?
#        layout = "admin/gw/mail_form"
#      end
#    end
    layout
  end

  def switch_redirect_url_options(current)
    _options = {}

    _my_clips     = '/_admin/video/my_clips'
    _shared_clips = '/_admin/video/shared_clips'
    _all_clips    = '/_admin/video/all_clips'

    if @admin_is
      if @item.editting_state == 'private' && @item.creator_id == Core.user.id
        _options[:location] = _my_clips
      elsif @item.editting_state == 'shared' && @item.editting_group_ids =~ /(^| )#{Core.user_group.id}( |$)/
        _options[:location] = _shared_clips
      else
        _options[:location] = _all_clips
      end

    elsif current == :shared
      _options[:location] = _my_clips if @item.private?
    elsif current == :mine
      _options[:location] = _shared_clips if @item.shared?
    end

    return _options
  end


end
