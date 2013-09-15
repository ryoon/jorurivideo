# encoding: utf-8
module Video::Controller::Accesses

  def log_access
    _view_count_mode = Application.config(:view_count_mode, "countup")
    #(_view_count_mode == "analyzable") ? write_log : countup
    case _view_count_mode
    when "both"
      countup
      write_log
    when "countup"
      countup
    when "analyzable"
      write_log
    else
    end
  end


private
  def write_log
    ## params
    @time    = Time.now
    accessed = @time.to_s(:db)
    ipaddr   = request.env['REMOTE_ADDR'].to_s
    #agent    = request.env['HTTP_USER_AGENT'].to_s
    content  = 'video' # params[:content]
    item_id  = params[:id]
    path     = params[:controller]
    #checkdigit = params[:checkdigit]

    ## validation
    error = nil
    #error = true if content =~ /\//

    ## puts log
    aclog = Video::DailyAccess.new(:content => content)
    unless error
      data = []
      [accessed, path, content, item_id, ipaddr].each do |v|
        v.gsub!(/\r\n|\r|\n/, '')
        v= '"' + v.gsub('"', '""') + '"' if v =~ /"/
        data << v
      end
      message = data.join(',')
      aclog.puts_log(message, :time => @time)
    end
  end

  def countup
    ## params
    item_id  = params[:id]

    clip = Video::Clip.new.find(:first, :conditions => {:id => item_id})
    clip.skip_upload
    #count up
    _current_count  = clip.view_count || 0
    clip.view_count = _current_count + 1

    Video::Clip.record_timestamps = false  # no update timestamps(created_at, updated_at)
    clip.save(:validate => false)
    Video::Clip.record_timestamps = true   # active update timestamps
  end




#  def read
#    @skip_layout = true
#    @no_cache    = true
#
#    ## params
#    @time    = Time.now
#    accessed = @time.to_s(:db)
#    ipaddr   = request.env['REMOTE_ADDR'].to_s
#    #agent    = request.env['HTTP_USER_AGENT'].to_s
#    content  = params[:content]
#    item_id  = params[:id]
#    path     = '/' + params[:path].join('/')
#
#    ## validation
#    error = nil
#    error = true if content =~ /\//
#
#    ## puts log
#    aclog = Cms::DailyAccess.new(:content => content)
#    unless error
#      data = []
#      [accessed, path, content, item_id, ipaddr].each do |v|
#        v.gsub!(/\r\n|\r|\n/, '')
#        v= '"' + v.gsub('"', '""') + '"' if v =~ /"/
#        data << v
#      end
#      message = data.join(',')
#
#      aclog.puts_log(message, :time => @time)
#    end
#
#    ## render
#    send_data(aclog.blank_gif, {:type => "image/gif", :filename => "blank.gif", :disposition => 'inline'})
#  end
end
