# encoding: utf-8
require 'digest/sha1'
class System::User < Sys::GwBase::GwDatabase
  include Sys::Model::Base
  include Sys::Model::Base::Config

  has_many :users_groups, :foreign_key => :user_id, :class_name => 'System::UsersGroup'
  has_many :groups, :through => :users_groups, :source => :group

end
