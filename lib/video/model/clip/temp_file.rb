# encoding: utf-8
module Video::Model::Clip::TempFile
  def self.included(mod)
    mod.validates_presence_of :file, :if => "@_skip_upload != true"
    mod.validates_presence_of :name, :title
    mod.validate :validate_file_name
    mod.validate :validate_upload_file
    mod.after_save :upload_internal_file
    mod.after_destroy :remove_internal_file
  end

  @@_upper_limit_file_size = 250 # MegaMytes
  @@_maxsize      = 200 # MegaMytes
  @@_maxduration  = 15 # Minutes
#  @@_maxwidth = 720
#  @@_maxheight = 480

  #@@_ffmpeg_cmd_path = "/usr/local/bin/"
#  @@_thumbnail_size  = {
#    'pc_list' => {:width => 160, :height => 120},
#    'pc_player' => {:width => 370, :height => 290}
#  }

  attr_accessor :file, :file_maxsize

  def upper_limit_file_size(v = '250')
    @@_upper_limit_file_size = v.to_i == 0 ? 250 : v.to_i
  end

  def maximum_file_size(v = '200')
    @@_maxsize = v.to_i == 0 ? 200 : v.to_i
  end

  def maximum_duration(v = '15')
    #@@_maxduration = v.to_i || 15
    @@_maxduration = v.to_i == 0 ? 15 : v.to_i
  end

  def skip_upload(bool = true)
    @_skip_upload = bool
  end

  # alert
  def add_to_alert(msg)
    #use only frame size check
    @alert = [] unless @alert
    @alert << msg
  end

  def alert
    return nil unless @alert
    @alert
  end

  def validate_file_name
    return true if name.blank?

    if self.name !~ /^[0-9a-zA-Z\-\_\.]+$/
      errors.add :name, "は半角英数字を入力してください。"
    elsif self.name.count('.') != 1
      errors.add(:name, 'を正しく入力してください。＜ファイル名.拡張子＞')
    elsif duplicated?
      errors.add :name, "は既に存在しています。"
      return false
    end
    self.title = self.name if title.blank?
  end

  def validate_upload_file
    return true if file.blank?

    upperlimit_size = @@_upper_limit_file_size
    if file.size > upperlimit_size.to_i  * (1024**2)
      raise "容量が制限を超えています。＜#{upperlimit_size}MB＞\n"
    end unless @slip_vallidation && @slip_vallidation[:skip_maxsize]

    _alert_msg = ''

    maxsize = @maxsize || file_maxsize || @@_maxsize
    if file.size > maxsize.to_i  * (1024**2)
      #errors.add :file, "が容量制限を超えています。＜#{maxsize}MB＞"
      #return true
      self.convert_state = "queue"
      _alert_msg =  "容量が基準値を超えています。＜#{maxsize}MB＞　#{maxsize}MB以内に自動圧縮されます。"
    end unless @slip_vallidation && @slip_vallidation[:skip_maxsize]

    self.mime_type    = file.content_type if self.mime_type.blank?
    self.size         = file.size
    self.width        = nil
    self.height       = nil
    self.duration     = nil
    self.extension    = nil
    self.bitrate      = nil
    self.audio_rate   = nil
    self.sampling_frequency = nil

    @_file_data = file.read

    # ffmpeg analyze
    if _result = analyze
      self.width      = _result[:width]
      self.height     = _result[:height]
      self.duration   = _result[:duration]
      self.extension  = _result[:extension]
      self.audio_rate = _result[:audio_rate]
      self.bitrate    = _result[:bitrate]
      self.sampling_frequency = _result[:sampling_frequency]
    else
      raise 'ファイルの解析に失敗しました。'
    end

    # format check
    if self.extension
      #raise 'アップロードされたファイルの形式は対応していません。' unless (self.extension =~ /flv/i || self.extension =~ /mp3/i)
      if self.extension =~ /flv/i || self.extension =~ /mp3/i
        #flv or mp3
        self.convert_state = "done" unless self.convert_state == "queue"
#      elsif self.extension =~ /asf|avi|mp4|mov/i
#        #wmv,avi,mp4,mov
      elsif self.extension =~ /(^|,)(asf|avi|mp4|mov|mpeg|matroska|webm|ogg|rm|mpegts)(,|$)/i
        #wmv,avi,mp4,mov (+mpeg,mkv,ogm,rm,rmvb,mts)
        self.convert_state = "queue"
        _alert_msg += "アップロードした動画はflv形式に自動変換されます。"
      else
        raise 'アップロードされたファイルの形式は対応していません。'
      end
    end

    #maxduration = @maxmaxduration || file_maxduration || @@_maxduration
    if self.duration
      maxduration = @@_maxduration
      self.duration =~ /(\d+):(\d+):(\d+).(\d+)/i
      _hour = $1
      _minute = $2
      _second = $3
      _maxminute = _hour.to_i * 60 + _minute.to_i
      _maxminute += 0.1 if _second.to_i > 0
      if _maxminute > maxduration.to_i
        raise "動画の登録可能制限時間＜#{maxduration}分＞を超えています。"
      end unless @slip_vallidation && @slip_vallidation[:skip_max_duration]
    end

    if !self.width.blank? && !self.height.blank?
      self.image_is     = 1
      _slip_vallidation = @slip_vallidation || {}

      if self.width > max_frame_size[:width] || self.height > max_frame_size[:height]
#        _msg = "動画の画面サイズが制限を超えています。＜#{max_frame_size[:width]}X#{max_frame_size[:height]}＞\n動画を再変換後、再度アップロードしてください。"
#        if _slip_vallidation[:skip_frame_size].to_s == 'alert'
#          add_to_alert _msg
#        else
#          raise _msg
#        end
        if _slip_vallidation[:skip_frame_size].to_s == 'alert'
          _alert_msg += "\n" unless _alert_msg == ''
          _alert_msg += "動画の画面サイズが制限を超えています。＜#{max_frame_size[:width]}X#{max_frame_size[:height]}＞"
          #add_to_alert _msg
        else
          self.convert_state = "queue"
          _alert_msg += "\n" unless _alert_msg == ''
          _alert_msg += "動画の画面サイズが制限を超えています。＜#{max_frame_size[:width]}X#{max_frame_size[:height]}＞\n制限サイズ内に納まるように自動縮小されます。"
          #add_to_alert _msg
        end
        #return true
      end unless _slip_vallidation[:skip_frame_size] == true
    end
    add_to_alert _alert_msg unless _alert_msg == ''
    return true
  end

  def upload_dir_path(options={})
    md_dir  = "#{self.class.to_s.underscore.pluralize}"
    id_dir  = format('%08d', id).gsub(/(.*)(..)(..)(..)$/, '\1/\2/\3/\4/\1\2\3\4')

    if options[:relative]
      "/_files/#{md_dir}/#{id_dir}"
    else
      "#{Rails.root}/upload/#{md_dir}/#{id_dir}"
    end
  end

  def upload_path(options={})
    id_file = format('%07d', id)
    id_file = "#{id_file}_org" if self.convert_state == "queue"
    "#{upload_dir_path(options)}/#{id_file}.dat"
  end

  def upload_uri
    upload_path({ :relative => true } )
  end

  def readable
    return self
  end

  def editable
    return self
  end

  def deletable
    return self
  end

  def readable?
    return true
  end

  def creatable?
    return true
  end

  def editable?
    return true
  end

  def deletable?
    return true
  end

  def image_file?
    #image_is == 1 ? true : nil
    return false
  end

  def escaped_name
    CGI::escape(name)
  end

  def united_name
    title + '(' + eng_unit + ')'
  end

  def alt
    title.blank? ? name : title
  end

  def image_size
    return '' unless image_file?
    "( #{image_width}x#{image_height} )"
  end

  def duplicated?
    nil
  end

  def css_class
    if ext = File::extname(name).downcase[1..5]
      conv = {
        'xlsx' => 'xls',
      }
      ext = conv[ext] if conv[ext]
      ext = ext.gsub(/[^0-9a-z]/, '')
      return 'iconFile icon' + ext.gsub(/\b\w/) {|word| word.upcase}
    end
    return 'iconFile'
  end

  def eng_unit
    _size = size
    return '' unless _size.to_s =~ /^[0-9]+$/
    if _size >= 10**9
      _kilo = 3
      _unit = 'G'
    elsif _size >= 10**6
      _kilo = 2
      _unit = 'M'
    elsif _size >= 10**3
      _kilo = 1
      _unit = 'K'
    else
      _kilo = 0
      _unit = ''
    end

    if _kilo > 0
      _size = (_size.to_f / (1024**_kilo)).to_s + '000'
      _keta = _size.index('.')
      if _keta == 3
        _size = _size.slice(0, 3)
      else
        _size = _size.to_f * (10**(3-_keta))
        _size = _size.to_f.ceil.to_f / (10**(3-_keta))
      end
    end

    #"#{_size}#{_unit}Bytes"
    "#{_size}#{_unit}B"
  end

  def reduced_size(options = {})
    return nil unless image_file?

    src_w  = image_width.to_f
    src_h  = image_height.to_f
    dst_w  = options[:width].to_f
    dst_h  = options[:height].to_f
    src_r    = (src_w / src_h)
    dst_r    = (dst_w / dst_h)
    if dst_r > src_r
      dst_w = (dst_h * src_r);
    else
      dst_h = (dst_w / src_r);
    end

    if options[:css]
      return "width: #{dst_w.ceil}px; height:#{dst_h.ceil}px;"
    end
    return {:width => dst_w.ceil, :height => dst_h.ceil}
  end

  def reduced_thumb_size(options = {})
    self.width  =  1 if self.width == nil
    self.height  = 1 if self.height == nil

    src_w  = width.to_f
    src_h  = height.to_f
    dst_w  = options[:width].to_f
    dst_h  = options[:height].to_f
    src_r    = (src_w / src_h)
    dst_r    = (dst_w / dst_h)
    if dst_r > src_r
      dst_w = (dst_h * src_r);
    else
      dst_h = (dst_w / src_r);
    end

    if options[:css]
      return "width: #{dst_w.ceil}px; height:#{dst_h.ceil}px;"
    end
    return {:width => dst_w.ceil, :height => dst_h.ceil}
  end



  def mobile_image(mobile)
    return nil unless mobile
    return nil if image_is != 1
    return nil if image_width <= 300 && image_height <= 400

    begin
      require 'RMagick'
      #info = Magick::Image::Info.new
      size = reduced_size(:width => 300, :height => 400)
      img  = Magick::Image.read(public_path).first
      img  = img.resize(size[:width], size[:height])

      case mobile
      when Jpmobile::Mobile::Docomo
        img.format = 'JPEG' if img.format == 'PNG'
      when Jpmobile::Mobile::Au
        img.format = 'PNG' if img.format == 'JPEG'
        img.format = 'GIF'
      when Jpmobile::Mobile::Softbank
        img.format = 'JPEG' if img.format == 'GIF'
      end
    rescue
      return nil
    end
    return img
  end

  def sound_thumbnail_path(type, options={} )
    thumb_file = case type
      when 'pc_list'
        'sound_thumb.jpg'
      else
        #default
        'sound.jpg'
    end
    "#{Rails.root}/public/_common/themes/admin/video/images/player/#{thumb_file}"
  end

  def thumbnail_path(type, options={} )
    # type : org, pc_player, pc_list, mobile_player, mobile_list
    thumb_file = case type
      when 'pc_player'
        'thumb_pc_player.jpg'
      when 'pc_list'
        'thumb_pc_list.jpg'
      else
        #org
        'thumb_org.jpg'
    end
    "#{upload_dir_path(options)}/#{thumb_file}";
  end

  def thumbnail_uri(type)
    "#{thumbnail_path(type, { :relative => true } )}";
  end


private
  ## filter/aftar_save
  def upload_internal_file
    unless @_file_data.blank?
      Util::File.put(upload_path, :data => @_file_data, :mkdir => true)
    end

    if self.image_is == 1
      ['org', 'pc_player', 'pc_list'].each do |type|
        thumb_path = thumbnail_path(type)
        FileUtils.remove_entry_secure(thumb_path) if FileTest.exist?(thumb_path)
      end
      # ffmpeg
      make_thumbnails(['pc_player', 'pc_list'])
    end
    return true
  end

  ## filter/aftar_destroy
  def remove_internal_file
    return true unless FileTest.exist?(upload_path)
    FileUtils.remove_entry_secure(upload_path)
    ['org', 'pc_player', 'pc_list'].each do |type|
      thumb_path = thumbnail_path(type)
      FileUtils.remove_entry_secure(thumb_path) if FileTest.exist?(thumb_path)
    end
    return true
  end
end