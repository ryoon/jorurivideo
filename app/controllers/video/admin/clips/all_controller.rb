# encoding: utf-8
class Video::Admin::Clips::AllController < Video::Admin::ClipsController
  layout :select_layout

  def pre_dispatch
    return redirect_to :action => 'index' if params[:reset]
    super()

    return error_auth unless @admin_is
  end

  def index
    init_action
    @category = nil
    if params[:cate] && !params[:cate].blank? && params[:cate].to_s != '0'
      if cate = Video::Category.find(params[:cate])
        @category = cate
      end
    end

    item = Video::Clip.new
    # condition
    item.category_is(@category) if @category
    item.and :creator_group_id, params[:group] if params[:group]
    item.and :published_year,   params[:year]  if params[:year]
    item.and :published_month,  params[:month] if params[:month]

    # search
    if params[:search]
      item.and :state, params[:s_status] if !params[:s_status].blank?
      item.and params[:s_column], "LIKE", "%#{params[:s_keyword]}%" if !params[:s_column].blank? && !params[:s_keyword].strip.blank?
      # user
      if u = Video::Base::User.find(:first, :conditions => {:account => params[:s_c_code] })
        item.and :creator_id, u.id
      else
        item.and '0', '1'
      end if params[:s_c_code] && !params[:s_c_code].blank?
      # group
      if g = Video::Base::Group.find(:first, :conditions => {:code => params[:s_g_code] })
        item.and :creator_group_id, g.id
      end if params[:s_g_code] && !params[:s_g_code].blank?
    end
    operator = (params[:s_negate] && !params[:s_negate].blank?) ? "IS NOT" : "IS"
    item.and :negated_at, operator, nil

    item.page  params[:page], @limit
    #item.order params[:sort], 'published_at DESC'
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end

  def show
    init_action
    @item = Video::Clip.new.find(params[:id])
    @item.skip_negate

    _show @item
  end

  def new
    init_action
    @item = Video::Clip.new({
      :state      => 'public',
      :editting_state => 'shared'
    })
    @item.tmp_id(:admin => @admin_is)
  end

  def create
    init_action
    @item = Video::Clip.new(params[:item])
    @item.initiarize_settings([@maximum_file_size])
    @item.skip_upload

    @item.admin_is = '1' if @admin_is

    _create @item do
      @item.skip_reduce_size if @admin_is
      @item.delay.convert_to_flv(@item) if @item.convert_state == 'queue'
    end
  end

  def update
    init_action
    @item = Video::Clip.new.find(params[:id])
    @item.initiarize_settings([@maximum_file_size])

    @item.stay_attributes
    @item.attributes = params[:item]
    @item.skip_upload

    _update @item
  end

  def negate
    init_action
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

  def destroy
    init_action
    @item = Video::Clip.new.find(params[:id])
    _destroy @item
  end

  def preview
    init_action
    #    item = Video::Clip.new.readable
    @item = Video::Clip.new.find(params[:id])
    @item.skip_negate

    #TODO:権限（公開範囲）チェック
  end

  def download
    #    item = Video::Clip.new.readable
    item = Video::Clip.new
    item.and :id, params[:id]
    return error_auth unless @file = item.find(:first)

    #TODO:権限（公開範囲）チェック

    if params[:thumb]
      thumbnail_path = @file.is_sound? ? @file.sound_thumbnail_path(params[:thumb]) : @file.thumbnail_path(params[:thumb])
      #send_file thumbnail_path, :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'
      filename = thumbnail_path
      headers['X-Sendfile'] = filename
      render :nothing => true
    else
      if params[:content]
        _filename = @file.name.gsub(/\.[a-z0-9]{2,}$/i, '.flv')
        send_file @file.upload_path, :type => @file.mime_type, :filename => _filename
      else
        #redirect_to @file.upload_uri
        filename = @file.upload_path
        headers['X-Sendfile'] = filename
        render :nothing => true
      end

      #redirect_to "/_common/test/jwplayer/video2.flv?start=#{params[:start]}"
    end
  end

  def pre_download
    return '' unless params[:tmp_id]

    item = Video::TempFile.new
    item.and "id", params[:id]
    item.and "tmp_id", params[:tmp_id]
    return '' unless file = item.find(:first)

    if params[:thumb]
      #send_file file.thumbnail_path('pc_player'), :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'
      filename = file.thumbnail_path('pc_player')
      headers['X-Sendfile'] = filename
      render :nothing => true
    else
      #send_file file.upload_path, :type => file.mime_type, :filename => file.name
      filename = file.upload_path
      headers['X-Sendfile'] = filename
      render :nothing => true
    end
  end

protected

  def select_layout
    layout = "admin/video/video"
    case params[:action].to_sym
      when :preview
        layout = "admin/video/preview"
    end
    layout
  end
end
