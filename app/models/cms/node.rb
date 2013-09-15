# encoding: utf-8
class Cms::Node < ActiveRecord::Base
  include Sys::Model::Base
  include Cms::Model::Base::Node
  include Sys::Model::Tree
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Publication
  include Cms::Model::Rel::Site
  include Cms::Model::Rel::Concept
  include Cms::Model::Rel::Content
  include Cms::Model::Auth::Concept
  
  belongs_to :status,   :foreign_key => :state,      :class_name => 'Sys::Base::Status'
  belongs_to :layout,   :foreign_key => :layout_id,  :class_name => 'Cms::Layout'
  
  has_many   :children, :foreign_key => :parent_id,  :class_name => 'Cms::Node',
    :order => :name, :dependent => :destroy
  
  validates_presence_of :state, :model, :name, :title
  
  def states
    [['公開','public'],['非公開','closed']]
  end
  
  def self.find_by_uri(path, site_id)
    return nil if path.to_s == ''
    
    cond = {:site_id => site_id, :parent_id => 0, :name => '/'}
    unless item = self.find(:first, :conditions => cond, :order => :id)
      return nil
    end
    return item if path == '/'
    
    path.split('/').each do |p|
      next if p == ''
      cond = {:site_id => site_id, :parent_id => item.id, :name => p}
      unless item = self.find(:first, :conditions => cond, :order => :id)
        return nil
      end
    end
    return item
  end
  
  def inherited_concept(key = nil)
    return @_inherited_concept if @_inherited_concept
    concept_id = concept_id
    parents_tree.each do |r|
      concept_id = r.concept_id if r.concept_id
    end unless concept_id
    return nil unless concept_id
    return nil unless @_inherited_concept = Cms::Concept.find(:first, :conditions => {:id => concept_id})
    key.nil? ? @_inherited_concept : @_inherited_concept.send(key)
  end
  
  def inherited_layout
    layout_id = layout_id
    parents_tree.each do |r|
      layout_id = r.layout_id if r.layout_id
    end unless layout_id
    Cms::Layout.find(:first, :conditions => {:id => layout_id})
  end
  
  def all_nodes_with_level
    search = lambda do |current, level|
      _nodes = {:level => level, :item => current, :children => nil}
      return _nodes if level >= 10
      return _nodes if current.children.size == 0
      
      _tmp = []
      current.children.each do |child|
        next unless _c = search.call(child, level + 1)
        _tmp << _c
      end
      _nodes[:children] = _tmp
      return _nodes
    end
    
    search.call(self, 0)
  end
  
  def all_nodes_collection(options = {})
    collection = lambda do |current, level|
      title = ''
      if level > 0
        (level - 0).times {|i| title += options[:indent] || '  '}
        title += options[:child] || ' ' if level > 0
      end
      title += current[:item].title
      list = [[title, current[:item].id]]
      return list unless current[:children]
      
      current[:children].each do |child|
        list += collection.call(child, level + 1)
      end
      return list
    end
    
    collection.call(all_nodes_with_level, 0)
  end
  
  def public_uri
    uri = site.uri
    parents_tree.each{|n| uri += "#{n.name}/" if n.name != '/' }
    uri = uri.gsub(/\/$/, '') if directory == 0
    uri
  end
  
  def public_full_uri
    uri = site.full_uri
    parents_tree.each{|n| uri += "#{n.name}/" if n.name != '/' }
    uri = uri.gsub(/\/$/, '') if directory == 0
    uri
  end
  
  def css_id
    ''
  end
  
  def css_class
    return 'content content' + self.controller.singularize.camelize
  end
end