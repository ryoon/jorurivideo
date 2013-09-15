# encoding: utf-8
class Sns::Admin::TestsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout :select_layout

  def index
#  tmp = Sns::Profile.new( :name => 'HIRAO', :age => 27 )
#  tmp.save
    @profile = Sns::Profile.find( :first, :conditions => {:user_id => Core.user.id} )
    if @profile.blank?
      @profile = Sns::Profile.create(:user_id=>Core.user.id , :name=>Core.user.name)
    end
  end

  def create
    item = Sns::Test.new
    unless params[:item][:text].blank?
      item.text = params[:item][:text]
      item.created_user_id = params[:item][:created_user_id]
      item.save
    end
    return redirect_to sns_profiles_path
  end

  def destroy
    item = Sns::Test.find(params[:id])
    item.destroy
    return redirect_to sns_profiles_path
  end

protected

  def select_layout
    layout = "admin/sns/sns"
    layout
  end

end
