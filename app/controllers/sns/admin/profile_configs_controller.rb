# encoding: utf-8
class Sns::Admin::ProfileConfigsController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  layout :select_layout

  def init_params
    @profile = Sns::Profile.find( :first, :conditions => {:user_id => Core.user.id} )
    if @profile.blank?
      @profile = Sns::Profile.create(:user_id=>Core.user.id , :name=>Core.user.name)
    end
    @edit_current = "photo"
    @edit_current = params[:cl] unless params[:cl].blank?

    #@show_current = "public"
    #@show_current = params[:cat] unless params[:cat].blank?
  end

  def index
    init_params

  end

  def new
    init_params
  end

  def create
    init_params
    return redirect_to :action => 'index'
  end

  def edit
    init_params
    @item = Sns::Profile.find(params[:id])
  end

  def update
    init_params
    @item = Sns::Profile.find(params[:id])
    if @edit_current == "base"
      birth_str = %Q(#{params[:item]['birthday(1i)']}-#{params[:item]['birthday(2i)']}-#{params[:item]['birthday(3i)']})
      params[:item].delete "birthday(1i)"
      params[:item].delete "birthday(2i)"
      params[:item].delete "birthday(3i)"
      if birth_str.blank?
        params[:item][:birthday]= nil
      else
        params[:item][:birthday]= birth_str
      end
    end
    @item.update_attributes(params[:item])
    #options = {:location=>url_for(:action => :edit, params=>{:id=>params[:id], :edit_current=>@edit_current})}
    #_update @item,options
    if @item.save
      flash[:notice] = "プロフィールを編集しました。"
      return redirect_to %Q(#{edit_sns_profile_config_path(@item)}?cl=#{@edit_current})
    else
      render :action=>:edit
    end
  end

  def show
    init_params
    @item = Sns::Profile.find(params[:id])
  end

  def destroy
    init_params
  end

protected

  def select_layout
    layout = "admin/sns/sns"
    layout
  end

end
