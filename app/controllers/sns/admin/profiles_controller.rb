# encoding: utf-8
class Sns::Admin::ProfilesController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout :select_layout

  def index
#  tmp = Sns::Profile.new( :name => 'HIRAO', :age => 27 )
#  tmp.save
    @profile = Sns::Profile.find( :first, :conditions => {:user_id => Core.user.id} )
    if @profile.blank?
      @profile = Sns::Profile.create(:user_id=>Core.user.id , :name=>Core.user.name, :account=>Core.user.account)
    else
      if @profile.account.blank?
        @profile.account = Core.user.account
        @profile.save
      end
    end

    @feeds = Sns::Test.limit(20).desc(:created_at)
  end

  #def show
  #  @item = Sns::Profile.find( :first, :conditions => {:account => Core.user.account} )
  #end

protected

  def select_layout
    layout = "admin/sns/sns"
    layout
  end

end
