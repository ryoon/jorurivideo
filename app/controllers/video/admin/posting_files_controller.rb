# encoding: utf-8
class Video::Admin::PostingFilesController < ApplicationController
  include Sys::Controller::Scaffold::Base

  protect_from_forgery :except => [:create]
  before_filter :cookie_only_off

  def init_action
    @upper_limit_file_size = Video::AdminSetting.config('upper_limit_file_size')
    @maximum_file_size     = Video::AdminSetting.config('maximum_file_size')
    @maximum_frame_size    = Video::AdminSetting.config('maximum_frame_size')
    @maximum_duration      = Video::AdminSetting.config('maximum_duration')
  end

  ## need tmp_id
  def index
    return http_error(404) if params[:tmp_id].blank?

    cond = { :tmp_id => params[:tmp_id], :admin_is => 0}
    files = Video::TempFile.find(:all, :conditions => cond).collect do |f|
      { :id   => f.id,
        :name => f.name,
        :size => f.size,
        :eng_unit => f.eng_unit,
        :image_is => f.image_is
      }
    end

    respond_to do |format|
      format.html { render :text => "" }
      format.xml  { render :xml => files.to_xml(:children => "item", :root => "items", :dasherize => false, :skip_types => true) }
    end
  end

  def show
    return http_error(404) if params[:tmp_id].blank?

    file = Video::TempFile.new
    file.and "id", params[:id]
    file.and "tmp_id", params[:tmp_id]
    @file = file.find(:first)
    return http_error(404) unless @file
    return http_error(404) unless params[:filename] == @file.name

    filename = @file.name.gsub(/[\/\<\>\|:"\?\*\\]/, '_')
    filename = URI::escape(filename) if request.env['HTTP_USER_AGENT'] =~ /MSIE/

    send_file @file.upload_path, :type => @file.mime_type, :filename => filename
  end


  def create
    init_action
    raise "送信パラメータが不正です。"             if params[:tmp_id].blank?
    raise "ファイルがアップロードされていません。" if params[:file].blank?


    _thumbnail_point = params[:thumbnail_point] || '1'
    cond = { :tmp_id => params[:tmp_id], :thumbnail_point => _thumbnail_point }
    file = Video::TempFile.new(cond)
    file.initiarize_settings([@upper_limit_file_size, @maximum_file_size, @maximum_frame_size, @maximum_duration])

    #admin is
    if ad = Video::TempFile.new.find(:first, :conditions => {:tmp_id => params[:tmp_id], :admin_is => 1})
      file.slip_vallidation({:skip_maxsize => true, :skip_frame_size => 'alert', :skip_max_duration => true })
    end

    begin
      rs = file.save_file(params[:file])
    rescue => e
      raise "ファイルの保存に失敗しました。#{e}"
    end
    raise file.errors.full_messages.join("\n") unless rs

    raise "ファイルが存在しません。(#{file.upload_path})" unless FileTest.file?(file.upload_path)

    ## garbage collect
    Video::TempFile.garbage_collect if rand(100) == 0

    #load temp data
    dl_uri = "/_admin/video/clip_files/#{params[:tmp_id]}/pre_download"

    _sate  = file.alert ? 'Alert' : 'OK';
    _alert = (file.alert && file.alert[0]) ? file.alert[0] : '' ;

    require 'kconv'
    return render :text => "#{_sate} #{file.id} #{NKF.nkf('-wxm0', file.name)} #{file.eng_unit} #{file.image_is} #{dl_uri} #{_alert}"
  rescue => e
    render :text => "Error #{e}"
  end

  def destroy
    raise "送信パラメータが不正です。" if params[:tmp_id].blank?

    cond = {:id => params[:id], :tmp_id => params[:tmp_id]}
    Video::TempFile.destroy_all(cond)

    render :text => "OK #{params[:id]}"
  rescue => e
    return http_error(404)
  end


  def thumbnail
    raise "送信パラメータが不正です。" if (params[:tmp_id].blank? || params[:id].blank?) && params[:item_id].blank?

    thumb_uri = ''
    if params[:id] == 'update'
      #update
      raise 'ファイルが存在しません。' unless item = Video::Clip.new.find(params[:item_id])
      item.stay_attributes
      item.attributes = {:thumbnail_point => params[:thumb_point] }
      item.skip_upload
      item.save
      #thumb_uri = item.thumbnail_uri('pc_player')   # TODO:変更必要　プログラムをかいする必要あり
      thumb_uri = "/_admin/video/my_clips/#{item.id}/download?thumb=pc_player"
    else
      #new
      tmp = Video::TempFile.new
      tmp.and "id", params[:id]
      tmp.and "tmp_id", params[:tmp_id]
      file = tmp.find(:first)
      raise "ファイルが存在しません。" unless file
      file.attributes = {:thumbnail_point => params[:thumb_point] }
      file.skip_upload
      file.save(:validate => false)
      #load temp data
      thumb_uri = "/_admin/video/clip_files/#{params[:tmp_id]}/pre_download"

    end
    return render :text => "OK #{thumb_uri}"
  rescue => e
    render :text => "Error #{e}"
  end

protected
  def cookie_only_off
    request.session_options[:cookie_only] = false
    request.session_options[:only]        = :create
  end
end
