# encoding: utf-8
class Video::AdminSetting < ActiveRecord::Base
  include Sys::Model::Base

  attr_accessor :form_type, :options

  #belongs_to :content, :foreign_key => :content_id, :class_name => 'Cms::Content'
  #belongs_to :user,  :foreign_key => :user_id,  :class_name => 'Video::Base::User'
  #belongs_to :group, :foreign_key => :group_id, :class_name => 'Video::Base::Group'

  #validates_presence_of :user_id, :name
  validates_presence_of :name

  def self.set_config(id, params = {})
    @@configs ||= {}
    @@configs[self] ||= []
    @@configs[self] << params.merge(:id => id)
  end

  def self.configs
    configs = []
    @@configs[self].each {|c| configs << config(c[:id])}
    configs
  end

  def self.config(name)
    cond = {:name => name.to_s}
    self.find(:first, :conditions => cond) || self.new(cond)
  end

	def self.value(name)
		conf = self.config(name)
		return conf.value if conf
	end

  def editable?
    #content.editable?
    #TODO:
    return true
  end

  def config
    return @config if @config
    @@configs[self.class].each {|c| return @config = c if c[:id].to_s == name.to_s}
    nil
  end

  def config_name
    config ? config[:name] : nil
  end

  def config_options
    case name
    when 'default_skin'
      skins = Video::Skin.new.enabled.find(:all, :order => 'sort_no')
      return skins.collect{ |s| [s.title, s.id.to_s] }
    end

    # default logic
    config ? config[:options] : nil
  end

  def value_name
    if !value.blank?
      case name
      when 'default_skin'
        skin = Video::Skin.find_by_id(value)
        return skin.title if skin
      end
    end

    # default logic
    if config[:options]
      config[:options].each {|c| return c[0] if c[1].to_s == value.to_s}
    else
      return value if !value.blank?
    end
    nil
  end

  # initialize
  set_config :default_skin,           :name => "デフォルト スキン"
  set_config :upper_limit_file_size,  :name => "動画ファイル最大サイズ（MB）"
  set_config :maximum_file_size,      :name => "動画ファイル基準サイズ（MB）"
  set_config :maximum_frame_size,     :name => "基準フレームサイズ[横x縦]（px）"
  set_config :maximum_duration,       :name => "登録可能制限時間（分）"
  set_config :maximum_monthly_report_count, :name=> "月別表示数(ヶ月分)"
end
