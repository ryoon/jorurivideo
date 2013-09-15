class Video::Admin::AdminMenusController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  layout :select_layout

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end

  def index
    init_action
  end

  def show
    error_auth
  end

  def new
    error_auth
  end

  def create
    error_auth
  end

  def update
    error_auth
  end

  def destroy
    error_auth
  end

protected
  def select_layout
    layout = "admin/video/video"
  end

end
