class Cms::Controller::Public::Base < Sys::Controller::Public::Base
  include Cms::Controller::Layout
  layout  'base'
  after_filter :render_public_layout
end
