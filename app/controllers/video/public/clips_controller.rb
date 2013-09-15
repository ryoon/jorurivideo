# encoding: utf-8
class Video::Public::ClipsController < ApplicationController #Cms::Controller::Public::Base
  include Video::Controller::Accesses

  def index
  end

  def show
    item = Video::Clip.new
    item.and :id, params[:id]
    return error_auth unless @clip = item.find(:first)
    return error_auth unless auth_checkdigit(@clip)
    @clip.set_options params

    render :layout => false
  end

  def download
    item = Video::Clip.new
    item.and :id, params[:id]
    return error_auth unless @file = item.find(:first)
    return error_auth unless auth_checkdigit(@file)

    if params[:format] == 'xml'
      respond_to do |format|
        format.xml  { render :xml => @file.to_playlist}
      end
    elsif params[:thumb]
      #send_file @file.thumbnail_path(params[:thumb]), :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'
      #redirect_to @file.thumbnail_uri(params[:thumb])

      filename = @file.thumbnail_path(params[:thumb])
      headers['X-Sendfile'] = filename
      render :nothing => true
    else
      # 再生回数＋貼り付け？サイト内？を保存
      return error_auth if @file.negated_at

      log_access
      redirect_uri = "#{@file.upload_uri}#{params[:start] ? '?start=' + params[:start]  : ''}"
      #dump redirect_uri

      #redirect_to redirect_uri
      filename = @file.upload_path
      headers['X-Sendfile'] = filename
      render :nothing => true
    end
  end

  def thumbnail
    item = Video::Clip.new
    item.and :id, params[:id]
    return error_auth unless @file = item.find(:first)
    return error_auth unless auth_checkdigit(@file)

    _thumb_type = 'pc_list'
    _thumb_type = params[:thumb] unless params[:thumb].blank?

    #send_file @file.read, :type => 'image/jpeg', :filename => 'thumb.jpg', :disposition => 'inline'

    #filename = @file.thumbnail_path(_thumb_type)
    filename = if @file.is_sound?
      @file.sound_thumbnail_path(_thumb_type)
    elsif @file.negated_at
      @file.negate_video_thumbnail_path(_thumb_type)
    else
      @file.thumbnail_path(_thumb_type)
    end

    headers['X-Sendfile'] = filename
    render :nothing => true
  end



private
  def auth_checkdigit(file)
    return false unless params[:checkdigit]
    return true if !file.check_digit && params[:checkdigit] == 'play'
    return true if file.check_digit && file.check_digit == params[:checkdigit]
    return false
  end

  def error_auth
    http_error 500, '権限がありません。'
  end

end
