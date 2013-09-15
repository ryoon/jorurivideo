# encoding: utf-8
class Video::Clip < ActiveRecord::Base
  include Sys::Model::Base
  include Video::Model::Clip::Config
  include Video::Model::Base::Ffmpeg
  include Video::Model::Clip::File
  include Video::Model::Base::Creator
  include Video::Model::Base::Setting
  include Video::Model::Clip::Category
  include Video::Model::Clip::Original

  include Video::Model::Auth::Member
  include Video::Model::Clip::EdittingGroup
  include Video::Model::Clip::Log

  belongs_to :status,         :foreign_key => :state,             :class_name => 'Video::Base::Status'

  has_many :accesses, :foreign_key => :item_id, :class_name => 'Video::DailyAccess',
    :order => :accessed_at, :dependent => :destroy

  validates_presence_of :title
  before_save :set_info

	def get_maximum_monthly_report_count
		self.initiarize_settings([@maximum_monthly_report_count])
		return @@_maximum_monthly_report_count
	end
	
  def set_info
    if Core.now && !self.created_at
      # created
      self.published_at = Core.now
      self.published_year  = self.published_at.year
      self.published_month = self.published_at.month.to_s.rjust(2, "0")
      self.published_day   = self.published_at.day.to_s.rjust(2, "0")
    end

    #check digit
    self.check_digit = create_check_digit unless self.check_digit

    return true
  end

  def create_check_digit
    candidates = ('a'..'z').to_a + ('0'..'9').to_a
    _token = (Array.new(20) do
              candidates[rand(candidates.size)]
            end
           ).join
    return _token
  end

  def set_options(params)
    @options = {}
    params.each do |n, v|
      next if v.to_s == ''
      case n
      when 'logo'
        @options[:logo] = false if v.to_s == 'n'
      when 'org'
        @options[:org] = true if v.to_s == 't'
      end
    end if params.size != 0
  end

  def get_options
    return @options if @options
    {}
  end

  def get_player_length(value, min, max)
		_length = if value <= min
                min
              elsif value > max
                max
              else
                value
              end
    _length
  end

  def get_view_properties(options={})
    _info = {}

    # default
    _default_player_width  = is_sound? ? Application.config(:default_player_width) : 0;
    _default_player_height = is_sound? ? Application.config(:default_player_height) : 0;

    # properties
    _player_width  = _default_player_width
    _player_height = _default_player_height

    if self.width && self.height
      _info[:stretching] = 'none' if self.width < _default_player_width && self.height < _default_player_height && !options[:window_full]

      _player_width  = get_player_length(self.width,  _default_player_width, Application.config(:maximum_frame_width))
      _player_height = get_player_length(self.height, _default_player_height, Application.config(:maximum_frame_height))
    end
    # (public side video)
    if options[:window_full]
      _player_width  = '100%'
      _player_height = '100%'
    end

    _info[:width]  = _player_width
    _info[:height] = _player_height
dump("_info.inspect:#{_info.inspect}")
    return _info
  end

  def embed_tag(options={})
    _vars              = get_vars(options)
    _player_properties = get_view_properties(options)

	# jw player 5.10
    _html = "<script type=\"text/javascript\" src=\"#{Core.full_uri}_common/swf/jwplayer/jwplayer.js\"></script>\n"
    _html += "<div id=\"jorurivideoplayer\">Please Wait</div>\n"
    _html += "<script type=\"text/javascript\">\n"
    _html += "//<![CDATA[\n"
    _html += "jwplayer(\"jorurivideoplayer\").setup({"
    _html += "flashplayer:\"#{Core.full_uri}_common/swf/jwplayer/player.swf\","
    _html += "height:\"#{_player_properties[:height]}\","
    _html += "width:\"#{_player_properties[:width]}\","
    _html += "file:\"#{_vars[:file_uri]}\","
    _html += "image:\"#{_vars[:thumbnail_uri]}\","
    _html += ""
    _html += ""
    _html += "provider:\"video\""
    _html += "});"
    _html += "\n//]]>\n"
    _html += "</script>"

    return _html
  end

  def to_playlist(options={})
    _vars = (options.length > 0) ? options : get_vars(options);

    _xml = "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
    _xml += "<playList version=\"1\" xmlns=\"http://xspf.org/ns/0/\">\n"
    _xml += "<trackList>\n"
    _xml += "<track>\n"
    _xml += "<title>#{CGI.escapeHTML(self.title)}</title>\n"
    _xml += "<location>#{_vars[:file_uri]}</location>\n"
    _xml += "<image>#{_vars[:thumbnail_uri]}</image>\n"
    _xml += "</track>\n"
    _xml += "</trackList>\n"
    _xml += "</playList>"
  end

  def to_public_player_uri(options={})
    _check_digit = self.check_digit || 'play'
    qs = ''
    qs += "logo=#{options[:logo]}" if options[:logo]
    qs = "?#{qs}" unless qs == ''
    "#{Core.full_uri}_public/video/clips/#{self.id}/#{_check_digit}/show#{qs}"
  end

  def get_vars(options={})
    _vars = {}
    #video
    _preview_controller = if mine?
        'my_clips'
      elsif sharable?
        'shared_clips'
      elsif public?
        'clips'
      else
        'all_clips'
      end if options[:preview]

    _check_digit = self.check_digit || 'play'

    _file_url = options[:preview] ? "#{Core.full_uri}_admin/video/#{_preview_controller}/#{self.id}/download" : "#{Core.full_uri}_public/video/clips/#{self.id}/#{_check_digit}/download"
    #thumbnail
    #_thumb_url ="#{_file_url}?thumb=true"
    _thumb_url =""
    #playlist
    _playlist_url = "#{_file_url}.xml"

    # TODO:仮処理
    if is_sound?
      # sound
      _file_url += ".mp3"
      #thumbnail
      _thumb_url = sound_thumbnail_uri
    else
      # video
      _file_url += ".flv"
      #thumbnail
      _thumb_url ="#{_file_url}?thumb=true"
    end

    # negate
    if self.negated_at && !@_skip_negate
      _thumb_url = negate_video_thumbnail_uri
      _file_url  = negate_video_thumbnail_uri
    end

    _vars[:thumbnail_uri] = _thumb_url
    _vars[:file_uri]      = _file_url
    _vars[:playlist_uri]  = _playlist_url

    return _vars
  end


  def skin
    return @sk if @sk
    if self.skin_id
      m = Video::Skin.new.enabled
      m.and :id, self.skin_id
      sk = m.find(:first);
      return sk if sk
    end
    # setting
    return nil unless s = setting('default_skin', {:admin_setting => true} )
    return nil if s.value.blank?

    m = Video::Skin.new.enabled
    m.and :id, s.value
    @sk = m.find(:first);
    return @sk
  end


  def find_creator_groups(*args)
    # simple
#    groups = self.class.find(:all , :select => "distinct creator_group_id",
#                             :order => "creator_group_id")

    # with count
    _clip = self.class.new.public
    groups = _clip.find(:all , :select => "creator_group_id, count(*) as cnt",
                          :group => "creator_group_id", :order => "creator_group_id")
    return groups
  end

  def find_monthly_groups(options={})
    # with count
		#　抽出月数
		limit = options[:maximum_monthly_report_count] || @@_maximum_monthly_report_count
		_clip = self.class.new.public
    groups = _clip.find(:all, :select => "published_year, published_month, count(*) as cnt",
                          :group => "published_year, published_month", :order => "published_year DESC, published_month DESC", :limit => limit)
		return groups
  end

  def find_category_groups(*args)
    # with count
    groups = self.class.find(:all , :select => "main_category_id, count(*) as cnt", :conditions => "state = 'public'",
                             :group => "main_category_id", :order => "main_category_id")
    return groups
  end


  def is_new?
    #self.id == nil
    !@tmp_id.blank?
  end

  def is_sound?(option={})
    return self.mime_type =~ /^audio/i if option[:mime]
    return (self.width.blank? && self.height.blank?)
  end

  def stay_attributes
    @stayed_attributes = {:editting_state => self.editting_state,
                          :thumbnail_point => self.thumbnail_point,
                          :editting_group_ids => self.editting_group_ids
                          }
  end

  def display_duration
    return '' unless self.duration
    self.duration =~ /(\d+):(\d+):(\d+).(\d+)/i
    _hour = $1
    _minute = $2
    _second = $3
    # "#{_hour.to_i * 60 + _minute.to_i}分#{_second}秒"
    "#{_hour.to_i * 60 + _minute.to_i}:#{_second}"
  end

  def display_frame_size
    return "" if is_sound?
    return "#{self.width}x#{self.height}" if self.width && self.height
    " - "
  end


  #TODO:
  def negate_label
    self.negated_at ? '論理削除の解除' : '論理削除';
  end

  def skip_negate(bool = true)
    @_skip_negate = bool
  end

  def display_title(options={})
    _display = ''
    arr_title = self.title.split(//u)
    if arr_title.size > 27
      _display = "#{arr_title[0 .. 26] * ""} ..."
    else
      _display = self.title
    end
    _display
  end

  def display_body(options={})
    _display = ''
    arr_body = self.body.split(//u)
    if arr_body.size > 65
      _display = "#{arr_body[0 .. 64] * ""} ..."
    else
      _display = self.body
    end
    _display
  end




#  def tmp_id=(val=nil)
#    @tmp_id = val
#  end
#  def tmp_id
#    #TODO:新規の場合と採番ずみの場合もあるので考慮！！
#    return @tmp_id if @tmp_id
#    @tmp_id = Video::TempFile.new_tmp_id
#    @tmp_id
#  end


  # TODO:仮
  def video_uri
    nil
  end

end
