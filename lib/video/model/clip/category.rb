# encoding: utf-8
module Video::Model::Clip::Category
  def self.included(mod)
    mod.belongs_to :main_category,  :foreign_key => :main_category_id,     :class_name => 'Video::Category'

    mod.validate    :validate_categories
    mod.before_save :set_main
  end

  attr_accessor :in_category_ids

  def in_category_ids
    unless val = read_attribute(:in_category_ids)
      write_attribute(:in_category_ids, category_ids.to_s.split(' ').uniq)
    end
    read_attribute(:in_category_ids)
  end

  def in_category_ids=(ids)
    _ids = []
    if ids.class == Array
      ids.each {|val| _ids << val}
      write_attribute(:category_ids, _ids.join(' '))
    elsif ids.class == Hash || ids.class == HashWithIndifferentAccess
      ids.each {|key, val| _ids << val}
      write_attribute(:category_ids, _ids.join(' '))
    else
      write_attribute(:category_ids, ids)
    end
  end

  def validate_categories
    in_category_ids.to_s =~ /\[(.*?)\]/i
    if $1.to_s.size == 0
      errors.add :category_ids, 'を選択してください。'
    end
    return true
  end

  def set_main
    self.main_category_id = nil
    if in_category_ids && in_category_ids.size > 0
      ids = in_category_ids.to_s.split(' ').uniq
      self.main_category_id = ids[0].to_s.gsub(/\[|\"|\,|\]/, "") if ids.size > 0
    end
  end

  def category_items
    ids = category_ids.to_s.split(' ').uniq
    return [] if ids.size == 0
    item = Video::Category.new
    item.and :id, 'IN', ids
    item.find(:all)
  end

  def category_is(cate)
    return self if cate.blank?
    cate = [cate] unless cate.class == Array
    cate.each do |c|
      if c.level_no == 1
        cate += c.public_children
      end
    end
    cate = cate.uniq

    cond = Condition.new
    cate.each do |c|
      cond.or :category_ids, 'REGEXP', "(^| )#{c.id}( |$)"
    end
    self.and cond
  end

end