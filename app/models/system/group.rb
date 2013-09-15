# encoding: utf-8
class System::Group < Sys::GwBase::GwDatabase
  include Sys::Model::Base
  include Sys::Model::Base::Config


  has_many :users_groups, :foreign_key => :group_id, :class_name => 'System::UsersGroup'

  has_many :users, :through => :users_groups, :source => :user,
    :conditions => {:ldap => 1, :state => 'enabled'},
    :order =>  'system_users.email, system_users.code'
  has_many :enabled_users, :through => :users_groups, :source => :user,
    :conditions => {:state => 'enabled'},
    :order =>  'system_users.email, system_users.code'

  has_many :children  , :foreign_key => :parent_id, :class_name => 'System::Group',
    :conditions => {:ldap => 1, :state => 'enabled'},
    :order => :sort_no
  has_many :enabled_children  , :foreign_key => :parent_id, :class_name => 'System::Group',
    :conditions => {:state => 'enabled'},
    :order => :sort_no

end
