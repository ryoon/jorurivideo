# encoding: utf-8
class Cms::Piece < ActiveRecord::Base
  include Sys::Model::Base
  include ::Cms::Model::Base::Piece
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Sys::Model::Rel::Publication
  include Cms::Model::Rel::Site
  include Cms::Model::Rel::Concept
  include Cms::Model::Rel::Content
  include Cms::Model::Auth::Concept


  belongs_to :status,   :foreign_key => :state,      :class_name => 'Sys::Base::Status'

  validates_presence_of :state, :model, :name, :title
  
  def locale(name)
    model = self.class.to_s.underscore
    label = ''
    if model != 'cms/piece'
      label = I18n.t name, :scope => [:activerecord, :attributes, model]
      return label if label !~ /^translation missing:/
    end
    label = I18n.t name, :scope => [:activerecord, :attributes, 'cms/piece']
    return label =~ /^translation missing:/ ? name.to_s.humanize : label
  end
  
  def node_is(node)
  	layout = nil
    node = Cms::Node.find(:first, :conditions => {:id => node}) if node.class != Cms::Node
    layout = node.inherited_layout if node
    self.and :id, 'IN', layout.pieces if layout
  end
  
  def css_id
    name.gsub(/-/, '_').camelize(:lower)
  end
  
  def css_attributes
    attr = ''
    
    attr += ' id="' + css_id + '"' if css_id != ''
    
    _cls = 'piece'
    attr += ' class="' + _cls + '"' if _cls != ''
    
    attr
  end
end
