# encoding: utf-8
class Sns::Admin::ProfilePhotosController < Cms::Controller::Admin::Base
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
  end

  def create
    init_params
    @item = Sns::ProfilePhoto.new
    #params[:item][:sort_no] = Gw::PortalAdd.get_max_sort_no
    photo_upload = @item.photo_data_save(params, :create)
    if photo_upload
      flash[:notice] = "プロフィール画像を登録しました。"
      return redirect_to sns_profile_photos_path
    else
      flash[:notice] = "プロフィール画像の登録に失敗しました。"
      render :action=>:index
      return
    end
  end

  def destroy
    init_params
    @item = Sns::ProfilePhoto.find(params[:id])
    if @item.destroy
      @item.default_photo(@profile)
      flash[:notice] = "指定の画像を削除しました。"
    else
      flash[:notice] = "指定の画像の削除に失敗しました。"
    end
    return redirect_to sns_profile_photo_selects_path
  end

  def select
    init_params
    item = Sns::ProfilePhoto.find(params[:id])
    if item.blank?
      flash[:notice] = "プロフィール画像の変更に失敗しました。"
    else
      @profile.photo_id = item._id
      @profile.photo_path = item.file_path
      if @profile.save
        flash[:notice] = "プロフィール画像を変更しました。"
      else
        flash[:notice] = "プロフィール画像の変更に失敗しました。"
      end
    end
    return redirect_to sns_profile_photos_path
  end

protected

  def select_layout
    layout = "admin/sns/sns"
    layout
  end

end
