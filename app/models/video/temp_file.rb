# encoding: utf-8
require 'digest/md5'
class Video::TempFile < ActiveRecord::Base
  include Sys::Model::Base
  include Video::Model::Base::Ffmpeg
  include Video::Model::Clip::TempFile
  include Video::Model::Base::Setting


   def slip_vallidation(skips={})
     @slip_vallidation = skips if skips && skips.length > 0
   end

#  def read
#    self.class.new(upload_path).read
#  end

  def save_file(file)
    raise "ファイルがアップロードされていません。" if file.blank?
    self.file = file

#    self.mime_type = file.content_type
#    self.size      = file.size
#    raise "容量制限を超えています。＜#{@@_maxsize}MB＞" if size > (@@_maxsize.to_i * (1024**2))

    self.name    ||= file.original_filename
    self.title   ||= name
    raise "ファイル名を入力してください。" if name.blank?

    self.mime_type = MIME::Types.type_for(self.name)[0].to_s
    if self.mime_type.blank?
      self.mime_type = MIME.check_magics(file.path).type rescue "application/octet-stream"
    end

    self.admin_is     = 0
    self.image_is     = 0
    validate_upload_file
    begin
      save(:validate => false)
      #Util::File.put(upload_path, :data => @_file_data, :mkdir => true, :use_lock => false)
    rescue => e
      destroy
      raise e
    end
    return true
  rescue => e
    errors.add :base, e.to_s
    return false
  end

  def is_sound?(option={})
    return self.mime_type =~ /^audio/i if option[:mime]
    return (self.width.blank? && self.height.blank?)
  end


  ## garbage collect
  def self.garbage_collect
    conditions = Condition.new
    conditions.and :tmp_id, 'IS NOT', nil
    conditions.and :created_at, '<', (Date.strptime(Core.now, "%Y-%m-%d") - 2)
    destroy_all(conditions.where)
  end

  ## Remove the temporary flag.
#  def self.fix_tmp_files(tmp_id, parent_unid)
#    updates = {:parent_unid => parent_unid, :tmp_id => nil }
#    conditions = ["parent_unid IS NULL AND tmp_id = ?", tmp_id]
#    update_all(updates, conditions)
#  end

#  def self.new_tmp_id
#    connection.execute("INSERT INTO #{table_name} (id, tmp_id) VALUES (null, 0)")
#    id = find_by_sql("SELECT LAST_INSERT_ID() AS id")[0].id
#    connection.execute("DELETE FROM #{table_name} WHERE id = #{id}")
#    Digest::MD5.new.update(id.to_s)
#  end
  def self.new_tmp_id(options={})
    if options[:admin]
      connection.execute("INSERT INTO #{table_name} (id, tmp_id, created_at, admin_is) VALUES (null, 0, '#{Core.now}', 1)")
      id = find_by_sql("SELECT LAST_INSERT_ID() AS id")[0].id
      _tmp_id = Digest::MD5.new.update(id.to_s)
      connection.execute("UPDATE #{table_name} SET tmp_id = '#{_tmp_id}' WHERE id = #{id}")
      _tmp_id
    else
      connection.execute("INSERT INTO #{table_name} (id, tmp_id) VALUES (null, 0)")
      id = find_by_sql("SELECT LAST_INSERT_ID() AS id")[0].id
      connection.execute("DELETE FROM #{table_name} WHERE id = #{id}")
      Digest::MD5.new.update(id.to_s)
    end
  end




#  def duplicated?
#    file = self.class.new
#    file.and :id, "!=", id if id
#    file.and :name, name
#    if tmp_id
#      file.and :tmp_id, tmp_id
#      file.and :parent_unid, 'IS', nil
#    else
#      file.and :tmp_id, 'IS', nil
#      file.and :parent_unid, parent_unid
#    end
#    return file.find(:first)
#  end
end
