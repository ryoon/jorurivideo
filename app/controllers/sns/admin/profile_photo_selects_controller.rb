# encoding: utf-8
class Sns::Admin::ProfilePhotoSelectsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout :select_layout

  def init_params
    @edit_current = "photo"
    @profile = Sns::Profile.find( :first, :conditions => {:user_id => Core.user.id} )
    if @profile.blank?
      @profile = Sns::Profile.create(:user_id=>Core.user.id , :name=>Core.user.name)
    end
  end

  def index
    init_params
    skip_layout
    @photos = Sns::ProfilePhoto.find(:all, :conditions=>{:created_user_id => Core.user.id})
  end

protected

  def select_layout
    layout = "admin/sns/sns"
    layout
  end

end
