class Video::Admin::CategoriesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  layout :select_layout

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end

  def index
    init_action
    item = Video::Category.new#.readable
    item.page  params[:page], params[:limit]
    item.order params[:sort], :sort_no
    @items = item.find(:all)
    _index @items
  end

  def show
    init_action
    @item = Video::Category.new.find(params[:id])
    _show @item
  end

  def new
    init_action
    @item = Video::Category.new({
      :state      => 'enabled',
      :sort_no    => 1,
    })
  end

  def create
    init_action
    @item = Video::Category.new(params[:item])
    @item.parent_id = 0
    @item.level_no  = 1
    _create @item
  end

  def update
    init_action
    @item = Video::Category.new.find(params[:id])
    @item.attributes = params[:item]
    _update @item
  end

  def destroy
    @item = Video::Category.new.find(params[:id])
    _destroy @item
  end


protected

  def select_layout
    layout = "admin/video/video"
  end

end
