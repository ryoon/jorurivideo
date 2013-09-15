# encoding: utf-8
class Sys::GroupChange::Plan < Sys::GwBase::GwDatabase
  include Sys::Model::Base

  set_table_name  :system_group_updates

#  set_primary_key [:xxxx, :xxx] #dummy
#  set_inheritance_column :dummy
#
#  validates_uniqueness_of :dummy
#  validates_presence_of   :dummy

  has_many :existences, :foreign_key => :group_update_id  ,  :class_name => 'Sys::GroupChange::Existence'
  has_many :own_plans , :foreign_key => :old_code ,  :primary_key => :code, :class_name => 'Sys::GroupChange::Existence'


#   self.state.to_i
#    when 1
#      # 名称変更
#    when 2
#      # 新規
#    when 3
#      # 廃止
#    when 6
#      # 変更なし


  def add_state?
    state.to_i == 2
  end

  def dismantle_state?
    state.to_i == 3
  end

  def integrate_state?
    state.to_i == 6
  end

end