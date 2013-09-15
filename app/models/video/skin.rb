# encoding: utf-8
class Video::Skin < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Base::Config
  include Video::Model::Skin::File
  include Video::Model::Auth::Manager

  belongs_to :status , :foreign_key => :state     , :class_name => 'Sys::Base::Status'
#  belongs_to :concept, :foreign_key => :concept_id, :class_name => 'Cms::Concept'
#  belongs_to :site   , :foreign_key => :site_id   , :class_name => 'Cms::Site'
#  belongs_to :node   , :foreign_key => :node_id   , :class_name => 'Cms::DataFileNode'


  validate :validate_totalcount,
    :if => %Q(state == "enabled")



  after_destroy :remove_public_file



  def validate_totalcount
    dump 'check max count!'


    _max_count = 5
    _cnt = self.class.count("state = 'enabled'");

dump "今#{_cnt}件"

    errors.add_to_base "登録可能な件数を超えています。＜最大#{_max_count}件＞" if _cnt >= _max_count
  end

  def public_path
    #return nil unless site
    #dir = Util::String::CheckDigit.check(format('%07d', id)).gsub(/(.*)(..)(..)(..)$/, '\1/\2/\3/\4/\1\2\3\4')
    #"#{site.public_path}/_files/#{dir}/#{escaped_name}"

    #TODO:swfファイルの場合は大丈夫だが、xml系のskinをアップ（zipファイル）出来るようにする場合は考慮必要！
    "#{Rails.public_path}/_common/swf/jwplayer/skins/#{escaped_name}"
  end

  def public_uri
    "/_common/swf/jwplayer/skins/#{escaped_name}"
  end

  def full_public_uri
    "#{Core.full_uri}_common/swf/jwplayer/skins/#{escaped_name}"
  end

#  def public_full_uri
#    "#{site.full_uri}#{public_uri.sub(/^\//, '')}"
#  end
#
#  def public
#    self.and :state, 'public'
#    self
#  end
#
#  def publishable?
#    return false unless editable?
#    return !public?
#  end
#
#  def closable?
#    return false unless editable?
#    return public?
#  end

  def public?
    return published_at != nil
  end

  def publish(options = {})
    unless FileTest.exist?(upload_path)
      errors.add_to_base 'ファイルデータが見つかりません。'
      return false
    end
    #self.state        = 'public'
    self.published_at = Core.now
    return false unless save(:validate => false)
    remove_public_file
    return upload_public_file
  end

#  def close
#    self.state        = 'closed'
#    self.published_at = nil
#    return false unless save(false)
#    return remove_public_file
#  end
#
#  def duplicated?
#    file = self.class.new
#    file.and :id, "!=", id if id
#    file.and :concept_id, concept_id
#    file.and :name, name
#    if node_id
#      file.and :node_id, node_id
#    else
#      file.and :node_id, 'IS', nil
#    end
#    return file.find(:first) != nil
#  end
#
#  def search(params)
#    params.each do |n, v|
#      next if v.to_s == ''
#
#      case n
#      when 's_node_id'
#        self.and :node_id, v
#      end
#    end if params.size != 0
#
#    return self
#  end

private
  def upload_public_file
    return false unless FileTest.exist?(upload_path)
    Util::File.put(public_path, :src => upload_path, :mkdir => true)
  end

  def remove_public_file
    return true unless FileTest.exist?(public_path)
    FileUtils.remove_entry_secure(public_path)
    return true
  end
end
