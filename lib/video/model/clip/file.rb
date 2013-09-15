# encoding: utf-8
module Video::Model::Clip::File
  def self.included(mod)
    mod.validates_presence_of :file, :if => "@_skip_upload != true"
##    mod.validates_presence_of :name, :title
##    mod.validate :validate_file_name
    mod.validate :validate_upload_file
    mod.after_save :upload_internal_file
    mod.after_destroy :remove_internal_file
  end

  @@_upper_limit_file_size = 250 # MegaMytes
  @@_maxsize = 200 # MegaMytes
	@@_maximum_monthly_report_count = 12 #12ヶ月
  attr_accessor :file, :file_maxsize, :file_id

  def upper_limit_file_size(v = '250')
    @@_upper_limit_file_size = v.to_i == 0 ? 250 : v.to_i
  end

  def maximum_file_size(v = '200')
    @@_maxsize = v.to_i == 0 ? 200 : v.to_i
  end

  def maximum_monthly_report_count(v = '12')
    @@_maximum_monthly_report_count = v.to_i < 0 ? 12 : v.to_i
  end

  def skip_after_save(bool = true)
    @_skip_after_save = bool
  end

  def skip_upload(bool = true)
    @_skip_upload = bool
  end

  def thumbnail_changed(bool = true)
    @_thumbnail_changed = bool
  end

  def skip_reduce_size(bool = true)
    @_skip_reduce_size = bool
  end

  def is_skip_reduce_size
    return @_skip_reduce_size if @_skip_reduce_size
    return false
  end


  def tmp_id=(val=nil)
    @tmp_id = val
  end
#  def tmp_id
#    return @tmp_id if @tmp_id
#    @tmp_id = self.id.blank? ? Video::TempFile.new_tmp_id : nil
#    @tmp_id
#  end

  def tmp_id(options={})
    return @tmp_id if @tmp_id
    @tmp_id = self.id.blank? ? Video::TempFile.new_tmp_id(options) : nil
    @tmp_id
  end

  def bitrate_value
    return '0' unless self.bitrate
    _value = '0'
    _value = self.bitrate.gsub(/k/i, '000')
    _value = _value.gsub(/m/i, '000000')
    _value = _value.gsub(/t/i, '000000000')
    _value = _value.gsub(/ /i, '')
    _value
  end

  def validate_upload_file
    #if @tmp_id && file_id
    if is_new?
      # new
      tmp = Video::TempFile.new
      tmp.and "id", file_id
      tmp.and "tmp_id", @tmp_id
      unless @file = tmp.find(:first)
        errors.add :file, "が登録されていません。"
        return true
      end

      unless self.thumbnail_point == @file.thumbnail_point
        thumbnail_changed
        @file.attributes = {:thumbnail_point => self.thumbnail_point }
      end

      # set attributes
      self.convert_state = @file.convert_state
      self.name          = @file.name
      self.mime_type     = @file.mime_type
      self.size          = @file.size
      self.width         = @file.width
      self.height        = @file.height
      self.duration      = @file.duration
      self.extension     = @file.extension
      self.bitrate       = @file.bitrate
      self.audio_rate    = @file.audio_rate
      self.sampling_frequency    = @file.sampling_frequency
    else
      thumbnail_changed unless self.thumbnail_point == @stayed_attributes[:thumbnail_point]
    end
  end

  def upload_dir_path(options={})
    md_dir  = "#{self.class.to_s.underscore.pluralize}"
    id_dir  = format('%08d', id).gsub(/(.*)(..)(..)(..)$/, '\1/\2/\3/\4/\1\2\3\4')
    #"#{Rails.root}/upload/#{md_dir}/#{id_dir}"

    if options[:relative]
      "/_files/#{md_dir}/#{id_dir}"
    else
      #"#{Rails.root}/public/_files/#{md_dir}/#{id_dir}"
      "#{Rails.root}/upload/#{md_dir}/#{id_dir}"
    end
  end

  def upload_path(options={})
    id_file = format('%07d', id)
    #id_file = "#{id_file}_org" if self.convert_state == "queue" || options[:org] == true

    id_file = "#{id_file}_org" if (!options.has_key?(:org) && self.convert_state != "done") || options[:org] == true
    "#{upload_dir_path(options)}/#{id_file}.dat"
  end

  def upload_uri
    upload_path({ :relative => true } )
  end


  def sound_thumbnail_path(type, options={})
    thumb_file = case type
      when 'pc_list'
        'sound_thumb.jpg'
      else
        #default
        'sound.jpg'
    end
    "#{Rails.root}/public/_common/themes/admin/video/images/player/#{thumb_file}"
  end

  def sound_thumbnail_uri
    "#{Core.full_uri}_common/themes/admin/video/images/player/sound.jpg"
  end

  def negate_video_thumbnail_path(type='', options={})
    thumb_file = case type
      when 'pc_list'
        'negate_video_thumb.jpg'
      else
        #default
        'negate_video.jpg'
    end
    "#{Rails.root}/public/_common/themes/admin/video/images/player/#{thumb_file}"
  end

  def negate_video_thumbnail_uri
    "#{Core.full_uri}_common/themes/admin/video/images/player/negate_video.jpg"
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


  def reduced_thumb_size(options = {})
#    self.width  =  120 if self.width == nil
#    self.height =  67 if self.height == nil
    self.width  =  130 if self.width == nil
    self.height =  73 if self.height == nil

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


  def convert_to_flv(item=nil)
dump "Start #{Time.now}"
    return false unless item
dump "   clip is #{item.id}"
    item.convert_state = 'start'
    item.skip_upload
    item.skip_after_save
    if item.save(:validate => false)
      # comvert
      _maximum_file_size   = Video::AdminSetting.config('maximum_file_size')
      _maximum_frame_size  = Video::AdminSetting.config('maximum_frame_size')
      item.initiarize_settings([_maximum_file_size, _maximum_frame_size])

      # maximum file size
      _maximum_file_size_i = _maximum_file_size.value.to_s == '' ? 200 : _maximum_file_size.value.to_i
      _maximum_file_size_i = _maximum_file_size_i  * (1024**2)

      # convert -------------------------------------------------------------------------------------
      _convert_base_tbl = item.max_frame_size
      current_index          = _convert_base_tbl[:width] < item.width ? convert_table_index(_convert_base_tbl[:width])  :   convert_table_index(item.width)

      _convert_bitrate_value = item.bitrate_value

      cnt      = 0
      finished = 10
      reduce_flg = true
      if item.size.to_i <= _maximum_file_size_i
        # one time
        finished = 1
        reduce_flg = false
      else
        _convert_bitrate_value = '192000'
      end

      while cnt < finished
        # set convert info
        _convert_base_tbl =  convert_table_value(current_index) if reduce_flg
        break unless _convert_base_tbl

        # convert start
        convert_result = nil
        if item.admin_is == 1 || (item.width < _convert_base_tbl[:width] && item.height < _convert_base_tbl[:height])
          convert_result = item.convert('flv')
        else
          _convert_tbl = item.reduced_thumb_size(_convert_base_tbl)
          if reduce_flg
            _convert_tbl[:bitrate]    = _convert_bitrate_value
            _convert_tbl[:frame_rate] = '12'
          end
          convert_result = item.convert('flv', _convert_tbl)
        end

        #update video attributes
        if convert_result
          item.width      = convert_result[:width]
          item.height     = convert_result[:height]
          item.duration   = convert_result[:duration]
          item.extension  = convert_result[:extension]
          item.audio_rate = convert_result[:audio_rate]
          item.bitrate    = convert_result[:bitrate]
          item.sampling_frequency = convert_result[:sampling_frequency]
        end
        begin
          # TODO:only convert flv
          item.mime_type = 'video/x-flv'
          f = File::stat(item.upload_path({:org => false}))
          item.size = f.size
dump "current file size = #{f.size} ?? max = #{_maximum_file_size_i}"
          break if f.size.to_i <= _maximum_file_size_i
        rescue => ex
          break;
        end
        break if item.admin_is == 1

        # set next info
#        _convert_bitrate_value      =  (_convert_bitrate_value.to_i * 0.8).to_s
#        cnt = cnt + 1
#        current_index = current_index + 1
#        reduce_flg = true

        _convert_pre_tbl =  convert_table_value((current_index + 1))
        unless _convert_pre_tbl
          finished += 1
          #current_index = current_index
          _convert_bitrate_value      =  (_convert_bitrate_value.to_i * 0.5).to_s
        else
          current_index = current_index + 1
          _convert_bitrate_value      =  (_convert_bitrate_value.to_i * 0.8).to_s
        end
        cnt = cnt + 1
        reduce_flg = true

        break if cnt > 15
      end

      item.convert_state = 'done'
      item.admin_is = '0'
      item.save(:validate => false)
dump "End #{Time.now}"
    end
  end


  def convert_table
    {
      0 => {:width => 800, :height=>600 },
      1 => {:width => 768, :height=>576 },
      2 => {:width => 704, :height=>528 },
      3 => {:width => 640, :height=>480 },
      4 => {:width => 576, :height=>432 },
      5 => {:width => 512, :height=>384 },
      6 => {:width => 448, :height=>336 },
      7 => {:width => 384, :height=>288 },
      8 => {:width => 320, :height=>240 }
    }
  end

  def convert_table_value(curren_indext=0)
    convert_table[curren_indext]
  end

  def convert_table_index(w, option={})
    convert_table.each_with_index do |v, i|
      if v[1][:width] <= w
        return i
      end
    end
  end


private
  ## filter/aftar_save
  def upload_internal_file
    unless @_skip_after_save
      if is_new?
        # new
        if @_thumbnail_changed
          ['org', 'pc_player', 'pc_list'].each do |type|
            thumb_path = @file.thumbnail_path(type)
            FileUtils.remove_entry_secure(thumb_path) if FileTest.exist?(thumb_path)
          end
          # ffmpeg
          @file.make_thumbnails(['pc_player', 'pc_list'])
        end

        # move to
        remove_internal_file
        require 'fileutils'
        dir = File.dirname(upload_path)
        FileUtils.mkdir_p(dir)
        FileUtils.mv(@file.upload_path, upload_path)
        ['org', 'pc_player', 'pc_list'].each do |type|
          _tmp_path = @file.thumbnail_path(type)
          FileUtils.mv(_tmp_path, thumbnail_path(type)) if FileTest.exist?(_tmp_path)
        end
      else
        # update
        if @_thumbnail_changed
          ['org', 'pc_player', 'pc_list'].each do |type|
            thumb_path = thumbnail_path(type)
            FileUtils.remove_entry_secure(thumb_path) if FileTest.exist?(thumb_path)
          end
          # ffmpeg
          make_thumbnails(['pc_player', 'pc_list'])
        end
      end
    end
    return true
  end

  ## filter/aftar_destroy
  def remove_internal_file
    return true unless FileTest.exist?(upload_path)
    FileUtils.remove_entry_secure(upload_path)
    FileUtils.remove_entry_secure(upload_path(:org => true)) if FileTest.exist?(upload_path(:org => true))
    ['org', 'pc_player', 'pc_list'].each do |type|
      thumb_path = thumbnail_path(type)
      FileUtils.remove_entry_secure(thumb_path) if FileTest.exist?(thumb_path)
    end
    return true
  end
end