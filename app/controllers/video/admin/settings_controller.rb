class Video::Admin::SettingsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  layout :select_layout

  def pre_dispatch
#    return error_auth unless Core.user.has_auth?(:designer)
    return error_auth unless @user = Video::Base::User.find(Core.user.id)
#    return error_auth unless @content.editable?
#    default_url_options :content => @content
#    return redirect_to(request.env['PATH_INFO']) if params[:reset]
  end

  def index
    init_action
    @items = Video::Setting.configs(@user)
    _index @items
  end

  def show
    init_action
    @item = Video::Setting.config(@user, params[:id])
    _show @item
  end

  def new
    error_auth
  end

  def create
    error_auth
  end

  def update
    @item = Video::Setting.config(@user, params[:id])
    @item.value = params[:item][:value]
    _update(@item)
  end

  def destroy
    error_auth
  end


protected
  def select_layout
    layout = "admin/video/video"
  end

end
