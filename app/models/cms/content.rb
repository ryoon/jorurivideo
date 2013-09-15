# encoding: utf-8
class Cms::Content < ActiveRecord::Base
  include Sys::Model::Base
  include Cms::Model::Base::Content
  include Sys::Model::Rel::Unid
  include Sys::Model::Rel::Creator
  include Cms::Model::Rel::Site
  include Cms::Model::Rel::Concept
  include Cms::Model::Auth::Concept

  validates_presence_of :state, :model, :name

  def states
    [['公開','public']]
  end

  def node_is(node)
    node = Cms::Node.find(:first, :conditions => {:id => node}) if node.class != Cms::Node
    self.and :id, node.content_id if node
  end
end
