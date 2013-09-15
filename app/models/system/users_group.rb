class System::UsersGroup < Sys::GwBase::GwDatabase
  include Sys::Model::Base
  include Sys::Model::Base::Config

  set_primary_key :rid

  belongs_to   :user,  :foreign_key => :user_id,  :class_name => 'System::User'
  belongs_to   :group, :foreign_key => :group_id, :class_name => 'System:Group'
end
