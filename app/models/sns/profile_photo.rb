# -*- encoding: utf-8 -*-
class Sns::ProfilePhoto
#  include Mongoid::Document
#  include Mongoid::Timestamps
#
#  after_destroy :destroy_file
#
#  field :file_name
#  field :file_path
#  field :file_directory
#  field :original_file_name
#  field :content_type
#  field :created_user_id
#
#  def photo_data_save(params, mode,options={})
#
#    extname_judges = [".jpeg", ".jpg", ".png", ".gif"]
#    par_item = params[:item].dup
#    #par_item = params[:item]
#    # parse options
#    file = par_item[:upload]
#    par_item.delete :upload
#    par_item.delete :local_file_path
#    update_image = Hash::new # 更新時、ファイルがアップロードされていない場合は、既存のファイル情報を継続させる。
#
#    unless file.blank?
#      upload_file = file.read
#      content_type = file.content_type
#      if /^image\// !~ content_type
#        self.errors.add :upload, '画像以外アップロードできません。'
#      end
#      original_file_name = file.original_filename # ファイル名
#      extname = File.extname(original_file_name) # 拡張子を抽出
#      if extname_judges.index(extname.downcase).blank? # downcase：小文字に揃える、index：配列を検索
#        self.errors.add :upload, 'jpeg, jpg, png, gifの拡張子以外の画像をアップロードできません。'
#      end
#      #image_size = r_magick(upload_file)
#      #unless image_size[0] == "failed"
#      #  if (image_size[1] > 170 or image_size[2] > 50)
#      #    errors <<  '画像のサイズは、横170ピクセル×縦50ピクセル以内にしてください。'
#      #  end
#      #end
#    else
#      if mode == :create
#        self.errors.add :upload, '画像ファイルを選択してください。'
#      elsif mode == :update
#        update_image[:file_path] = self.file_path
#        update_image[:file_directory] = self.file_directory
#        update_image[:file_name] = self.file_name
#        update_image[:original_file_name] = self.original_file_name
#        update_image[:content_type] = self.content_type
#        #image_size = ['success',self.width, self.height]
#      end
#    end
#
#    #item.update_attributes(image)
#    if mode == :update
#      save_flg = self.errors.size
#    elsif mode == :create
#      save_flg = self.errors.size
#    end
#
#    # 画像アップ
#    if save_flg && !file.blank?
#      image = Hash::new
#      image[:content_type] = file.content_type
#
#      image[:original_file_name] = original_file_name
#      directory = "/_common/themes/sns/files/profile/photos/#{Core.user.account}/#{self.id}/"
#      #image[:file_name] = filename
#      filename = "#{image[:original_file_name]}"
#      image[:file_name] = filename
#      image[:file_directory] = directory
#      image[:created_user_id] = Core.user.id
#      #image[:width] = image_size[1]
#      #image[:height] = image_size[2]
#      file_path = %Q(#{directory}#{filename})
#      image[:file_path] = file_path
#      upload_path = RAILS_ROOT
#      upload_path += '/' unless upload_path.ends_with?('/')
#      upload_path += "public#{file_path}"
#      unless mkdir_for_file upload_path
#        # ディレクトリが作成できない
#        self.errors.add :upload, 'ディレクトリが作成できません。'
#      end
#
#      if self.errors.size == 0
#        File.delete(upload_path) if File.exist?(upload_path)
#        File.open(upload_path, 'wb') { |f| f.write(upload_file) }
#        self.update_attributes(image)
#        self.save
#        resize_photo("#{RAILS_ROOT}/public#{self.file_path}")
#        return true
#      else
#        return false
#      end
#    elsif save_flg && file.blank? && mode == :update
#      # 既存データを保存
#      self.update_attributes(update_image)
#      self.save
#      #resize("#{RAILS_ROOT}/public#{item.file_path}")
#      return true
#    else
#      return false
#    end
#  end
#
#
#
#  def resize_photo(upload_path)
#    #縦横のサイズが130以上なら縮小する
#    image_size = photo_size(upload_path)
#    if image_size[0] == true
#      if image_size[1] > 130 || image_size[2] > 130
#        resize(upload_path)
#      end
#    end
#  end
#
#  #縦横サイズ取得
#  def photo_size(upload_path)
#    begin
#      require 'RMagick'
#      f = open(upload_path, "rb")
#      upload_file = f.read
#      image = Magick::Image.from_blob(upload_file).shift
#      if image.format =~ /(GIF|JPEG|PNG)/
#        result = true
#        width = image.columns
#        height = image.rows
#        readon = "ok"
#      else
#        result = false
#        width = 0
#        height = 0
#        readon = "format"
#      end
#    rescue
#      result = false
#      width = 0
#      height = 0
#      readon = "rmagickerr"
#    end
#    return [result,width,height,readon]
#  end
#
#  def resize(upload_path)
#    begin
#      require 'RMagick'
#      original = Magick::Image.read(upload_path).first
#      resized = original.resize_to_fit(130,130)
#      resized.write(upload_path)
#      return true
#    rescue
#      return false
#    end
#  end
#
#  def mkdir_for_file(path)
#    # 末尾が / ならディレクトリと見なし、存在しないならディレクトリを作成する
#    # 末尾が / 以外なら、ファイル名と見なし、そのファイル名を作成するのに必要なディレクトリが存在しないなら作成する
#    # 再帰的に必要なだけディレクトリを作成することに注意
#    # @return: 作成に成功したら true 失敗したら false
#    mode_file = !path.ends_with?('/')
#    px = path.split(/\//)
#    dir_name = px[0, px.length - (mode_file ? 1 : 0)].join(File::Separator)
#    ret = true
#    begin
#      FileUtils.mkdir_p(dir_name) unless File.exist?(dir_name)
#    rescue
#      ret = false
#    end
#    return ret
#  end
#
#  def destroy_file
#    src = "#{RAILS_ROOT}/public#{self.file_directory}"
#    FileUtils.rm_rf(src)
#    rescue => e
#  end
#
#  def default_photo(profile)
#    if self.file_path == profile.photo_path
#      profile.photo_id = nil
#      profile.photo_path = nil
#      profile.save
#    end
#  end
#
end
