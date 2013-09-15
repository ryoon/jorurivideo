class Video::Admin::MessagesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  layout :select_layout

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end

  def index
    init_action
    item = Sys::Maintenance.new#.readable
    item.page  params[:page], params[:limit]
    item.order params[:sort], 'published_at DESC'
    @items = item.find(:all)
    _index @items
  end

  def show
    init_action
    @item = Sys::Maintenance.new.find(params[:id])
    return error_auth unless @item.readable?

    _show @item
  end

  def new
    init_action
    @item = Sys::Maintenance.new({
      :state        => 'public',
      :published_at => Core.now,
    })
  end

  def create
    init_action
    @item = Sys::Maintenance.new(params[:item])
    _create @item
  end

  def update
    init_action
    @item = Sys::Maintenance.new.find(params[:id])
    @item.attributes = params[:item]
    _update @item
  end

  def destroy
    @item = Sys::Maintenance.new.find(params[:id])
    _destroy @item
  end


protected

  def select_layout
    layout = "admin/video/video"
  end

end
