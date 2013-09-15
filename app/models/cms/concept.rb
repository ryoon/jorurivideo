# encoding: utf-8
class Cms::Concept < ActiveRecord::Base
  include Sys::Model::Base
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Role
  include Sys::Model::Tree
  include Sys::Model::Base::Page
  include Sys::Model::Auth::Manager
  
  belongs_to :status  , :foreign_key => :state     , :class_name => 'Sys::Base::Status'
  
  has_many   :children, :foreign_key => :parent_id , :class_name => 'Cms::Concept',
    :order => :name, :dependent => :destroy
  has_many   :layouts , :foreign_key => :concept_id, :class_name => 'Cms::Layout',
    :order => :name, :dependent => :destroy
  has_many   :pieces  , :foreign_key => :concept_id, :class_name => 'Cms::Piece',
    :order => :name, :dependent => :destroy
  
  validates_presence_of :site_id, :state, :level_no, :name
  
  def validate
    if id != nil && id == parent_id
      errors.add :parent_id, "を正しく入力してください。"
    end
  end
  
  def readable_children
    item = Cms::Concept.new
    item.has_priv(:read, :user => Core.user)
    item.and :parent_id, (id || 0)
    item.and :site_id, Core.site.id
    item.and :state, 'public'
    item.find(:all, :order => :sort_no)
  end
  
  def parent
    self.class.find_by_id(parent_id)
  end
  
  def contents
    Cms::Content.find(:all, :conditions => {:concept_id => id}, :order => :name)
  end
  
  def self.find_by_path(path)
    return nil if path.to_s == ''
    parent_id = 0
    item = nil
    path.split('/').each do |name|
      cond = {:parent_id => parent_id, :name => name}
      unless item = self.find(:first, :conditions => cond, :order => :id)
        return nil
      end
      parent_id = item.id
    end
    return item
  end
  
  def path
    path = name
    id = self.parent_id
    lo = 0
    while item = Cms::Concept.find_by_id(id) do
      id = item.parent_id
      path = item.name + '/' + path
      lo += 1
      if lo > 100
        path = nil
        break
      end
    end if id > 0
    path
  end
end
