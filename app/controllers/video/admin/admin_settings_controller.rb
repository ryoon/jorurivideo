class Video::Admin::AdminSettingsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  include Video::Controller::Base
  layout :select_layout

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end

  def index
    init_action
    @items = Video::AdminSetting.configs
    _index @items
  end

  def show
    init_action
    @item = Video::AdminSetting.config(params[:id])
    _show @item
  end

  def new
    error_auth
  end

  def create
    error_auth
  end

  def update
    @item = Video::AdminSetting.config(params[:id])
		_maximum_frame_width = Application.config(:maximum_frame_width)
		_maximum_frame_height = Application.config(:maximum_frame_height)
		
    _value = ''
    if params[:id] == 'maximum_frame_size'
      _w_value_s = params[:item][:frame_size_w_value]
      _h_value_s = params[:item][:frame_size_h_value]

      if _w_value_s != '' || _h_value_s != ''
        _w_value = _maximum_frame_width
        _h_value = _maximum_frame_height

        # valid
        begin
          _w_value_i = _w_value_s.to_i
          _w_value   = _w_value_i if _w_value_i < _w_value && _w_value_i > 0
        rescue
          _w_value = _maximum_frame_width
        end
        begin
          _h_value_i = _h_value_s.to_i
          _h_value   = _h_value_i if _h_value_i < _h_value && _h_value_i > 0
        rescue
          _h_value = _maximum_frame_height
        end

        # set
        _value = _w_value.to_s
        _value += 'x'
        _value += _h_value.to_s
      end
    else
      _value = params[:item][:value]
    end

    @item.value = _value
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
