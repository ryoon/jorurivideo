# encoding: utf-8
module Video::Model::Base::Ffmpeg

  def self.included(mod)

  end

  # base
  @@_ffmpeg_cmd_path = "/usr/local/bin/"
  # video's definition
  #@@max_frame_size = {:width => 720, :height => 400}
  @@max_frame_size = {:width => Application.config(:maximum_frame_width), :height => Application.config(:maximum_frame_height)}
  @@_thumbnail_size  = {
    'pc_list' => {:width => 160, :height => 90},
    'pc_player' => {:width => 370, :height => 208}
  }

  def max_frame_size
    @@max_frame_size
  end

  def set_maximum_frame_size(v='800x600')
    v =~ /^(\d*?)x(\d*?)$/
    _v_width  = $1
    _v_height = $2

    _w_value = Application.config(:maximum_frame_width)
    _h_value = Application.config(:maximum_frame_height)

    # valid
    begin
      _w_value_i = _v_width.to_i
      _w_value   = _w_value_i if _w_value_i < _w_value && _w_value_i > 0
    rescue
      _w_value = Application.config(:maximum_frame_width)
    end
    begin
      _h_value_i = _v_height.to_i
      _h_value   = _h_value_i if _h_value_i < _h_value && _h_value_i > 0
    rescue
      _h_value = Application.config(:maximum_frame_height)
    end

    @@max_frame_size = {:width => _w_value, :height => _h_value}
  end


  def version
    # cmd = "ffmpeg -version"
    "0.8"
  end

  def analyze(file_path=nil, option={})
    return @result if @result && !option[:force]
    @result = {:duration => nil, :width => nil, :height => nil, :extension => nil, :bitrate=> nil, :audio_rate => nil, :sampling_frequency => nil}

    file_path = file_path ?  file_path : file.path

    cmd = "#{@@_ffmpeg_cmd_path}ffmpeg -i #{file_path} 2>&1"
    # dump "temp file path : #{file_path}"

    # exec command
    begin
      stdout = ''
      IO.popen(cmd, 'r') {|pipe|
        pipe.each("\n") {|line|
          stdout += line
        }
      }
      if !stdout.blank?
        # duration
        stdout =~ /Duration[ ]*:[ ]*(\d\d:\d\d:\d\d.\d\d)[,|]/
        @result[:duration] = $1

        # bitrate
        stdout =~ /Duration[ ]*:[ ]*\d\d:\d\d:\d\d.\d\d[,|].*?bitrate[ ]*:[ ]*(\d+[ ]*[kmt])b\/s/i
        @result[:bitrate] = $1

        # extension
        stdout =~ /Input #\d+, (.*?), from.*?$/
        @result[:extension] = $1

        # width x height
        # audio rate
        reg = /Stream #(.*?):[ ]*(.*?)$/
        stdout.scan(reg).each do |arr|
            if arr[1] =~ /Video.*?(\d*)x(\d*)/
              @result[:width]  = $1
              @result[:height] = $2
            elsif arr[1] =~ /Audio.*?:.*?(\d+[ ]*[kmt])b\/s/i
              @result[:audio_rate] = $1
              if arr[1] =~ /Audio.*?:.*?(\d+) Hz/i
                @result[:sampling_frequency] = $1
              end
            end
        end
      end
    rescue => ex
      @result = nil
      #dump 'Error'
      #dump ex
    end
    return @result
  end

  def make_thumbnails(thumb_infos=nil)

    #ffmpeg -i video.flv -vframes 1 -ss 1 -s 350x250 -an -deinterlace -f image2 -y thumb1.jpg
    ss = self.thumbnail_point.to_s =~ /^(\d+\.\d+)|\d+$/ ? self.thumbnail_point.to_f : 1;
    #dump ss

    output_file_path = thumbnail_path('org')
    cmd = "#{@@_ffmpeg_cmd_path}ffmpeg -i #{upload_path} -ss #{ss} -s #{self.width}x#{self.height} -an -deinterlace -f image2 -y #{output_file_path} 2>&1"

    #コマンドを実行し、サムネイル作成
    begin
      stdout = ''
      IO.popen(cmd, 'r') {|pipe|
        pipe.each("\n") {|line|
          #dump line
          #stdout += line
        }
      }

      #サムネイル作成
      thumb_infos.each do |type|
        thumb_path = thumbnail_path(type)

        unless self.width <= @@_thumbnail_size[type][:width] && self.height <= @@_thumbnail_size[type][:height]
          begin
            require 'RMagick'
            size = reduced_thumb_size(:width => @@_thumbnail_size[type][:width], :height => @@_thumbnail_size[type][:height])
            img  = Magick::Image.read(output_file_path).first
            img  = img.resize(size[:width], size[:height])

            Util::File.put(thumb_path, :data => img.to_blob, :mkdir => true)
          rescue => rmex
            dump 'Error RMagick'
            dump rmex
          end
        end
      end

    rescue => ex
      #dump 'Error'
      #dump ex
    end
    return true
  end

  def convert(to_extension='flv', option={})
    info = nil
    org_file_path    = upload_path(:org => true)
    output_file_path = upload_path(:org => false)

    _width           =  option[:width]      ? option[:width]      : self.width
    _height          =  option[:height]     ? option[:height]     : self.height
    _bitrate_value   = option[:bitrate]     ? option[:bitrate]    : self.bitrate_value
    _sampling_frequency = option[:sampling_frequency] ? option[:sampling_frequency] : self.sampling_frequency

    _frame_rate_option  = option[:frame_rate]  ? "-r #{option[:frame_rate]}" : nil

    # coordination
    _sampling_frequency = sampling_frequency_by_ext(_sampling_frequency)

    cmd = "#{@@_ffmpeg_cmd_path}ffmpeg -y -i #{org_file_path} -s #{_width}x#{_height} #{_frame_rate_option} -b #{_bitrate_value} -ar #{_sampling_frequency} #{output_file_path}.#{to_extension} 2>&1"
dump cmd
    #do convert
    begin
      stdout = ''
      IO.popen(cmd, 'r') {|pipe|
        pipe.each("\n") {|line|
          stdout += line
        }
      }
      FileUtils.mv("#{output_file_path}.#{to_extension}", output_file_path) if FileTest.exist?("#{output_file_path}.#{to_extension}")
      info = analyze(output_file_path, {:force => true})
    rescue => ex
      #dump 'Error'
      #dump ex
    end
    return info
  end


  def sampling_frequency_by_ext(current, ext='flv')
    _sampling_frequency = current
    if ext == 'flv'
      # flv support (44100, 22050, 11025) sample rate.
      begin
        _sampling_frequency_i = current.to_i
        if _sampling_frequency_i >= 44100
          _sampling_frequency = '44100'
        elsif _sampling_frequency_i < 44100 && _sampling_frequency_i >= 22050
          _sampling_frequency = '22050'
        elsif _sampling_frequency_i < 22050
          _sampling_frequency = '11025'
        end
      rescue => ex
      end
    end
    _sampling_frequency
  end

end
