# encoding: utf-8
class Video::Admin::Clips::SharedController < Video::Admin::ClipsController
  layout :select_layout

  def pre_dispatch
    super()
  end

  def index
    init_action
    @category = nil
    if params[:cate] && !params[:cate].blank? && params[:cate].to_s != '0'
      if cate = Video::Category.find(params[:cate])
        @category = cate
      end
    end

    item = Video::Clip.new.shared
    # condition
    item.category_is(@category) if @category
    item.and :creator_group_id, params[:group] if params[:group]
    item.and :published_year,   params[:year]  if params[:year]
    item.and :published_month,  params[:month] if params[:month]

    item.page  params[:page], @limit
    #item.order params[:sort], 'published_at DESC'
    item.order params[:sort], 'updated_at DESC'
    @items = item.find(:all)
    _index @items
  end

  def show
    init_action
    @item = Video::Clip.new.shared.find(params[:id])
    _show @item
  end

  def new
    init_action
    @item = Video::Clip.new({
      :state      => 'group',
      :editting_state => 'shared'
    })
    @item.tmp_id(:admin => @admin_is)
  end

  def create
    init_action
    @item = Video::Clip.new(params[:item])
    @item.initiarize_settings([@maximum_file_size, @maximum_frame_size])
    @item.skip_upload

    _create @item, switch_redirect_url_options(:shared) do
      @item.skip_reduce_size if @admin_is
      @item.delay.convert_to_flv(@item) if @item.convert_state == 'queue'
    end
  end

  def update
    init_action
    @item = Video::Clip.new.shared.find(params[:id])
    @item.initiarize_settings([@maximum_file_size, @maximum_frame_size])

#    # thumbnail point TODO:
#    old_thumbnail_point = @item.thumbnail_point
    @item.stay_attributes
    @item.attributes = params[:item]
    @item.skip_upload

    _update @item, switch_redirect_url_options(:shared)
  end

  def destroy
    init_action
    @item = Video::Clip.new.shared.find(params[:id])
    _destroy @item
  end

  def preview
    init_action
    #    item = Video::Clip.new.readable
    @item = Video::Clip.new.shared.find(params[:id])
  end

  def download
    #    item = Video::Clip.new.readable
    item = Video::Clip.new.shared
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
      thumbnail_path = file.is_sound? ? file.sound_thumbnail_path('pc_player') : file.thumbnail_path('pc_player')
      #send_file file.thumbnail_path('pc_player'), :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'
      filename = thumbnail_path
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
