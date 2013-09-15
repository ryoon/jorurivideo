class Video::Admin::SkinsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  #include Video::Controller::Scaffold::Publication

  layout :select_layout

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
#    return error_auth unless @content = Article::Content::Base.find(params[:content])
#    default_url_options :content => @content
#
#    if params[:parent] == '0'
#      @parent = Article::Category.new({
#        :level_no => 0
#      })
#      @parent.id = 0
#    else
#      @parent = Article::Category.new.find(params[:parent])
#    end
  end

  def index
    init_action
#    if params['s_node_id']
#      return redirect_to :action => 'index', :params => { :parent => params['s_node_id'] }
#    end
#
#    @nodes = Cms::DataFileNode.find(:all, :conditions => {:concept_id => Core.concept(:id)}, :order => :name)

    item = Video::Skin.new.readable
    #item.and 'node_id', @parent.id if @parent.id != 0
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'sort_no'
    @items = item.find(:all)
    _index @items
  end

  def show
    init_action
    item = Video::Skin.new.readable
    @item = item.find(params[:id])
    return error_auth unless @item.readable?

    _show @item
  end

  def new
    init_action
    @item = Video::Skin.new({
      :state      => 'enabled',
      :sort_no    => 1,
 #     :concept_id => Core.concept(:id),
    })
  end

  def create
    init_action
    @item = Video::Skin.new(params[:item])
    #@item.site_id = Core.site.id
    #@item.state   = 'public'
    _create @item do
      if @item.state == 'enabled'
        @item.skip_upload
        @item.publish
      end
    end
  end

  def update
    init_action
    @item = Video::Skin.new.find(params[:id])
    @item.attributes = params[:item]
    @item.skip_upload
    _update @item
  end

  def destroy
    @item = Video::Skin.new.find(params[:id])
    _destroy @item
  end

  def download
    item = Video::Skin.new.readable
    item.and :id, params[:id]
    return error_auth unless @file = item.find(:first)

    send_file @file.upload_path, :type => @file.mime_type, :filename => @file.name, :disposition => 'inline'
  end


protected

  def select_layout
    layout = "admin/video/video"
  end
end
