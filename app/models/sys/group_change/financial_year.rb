# encoding: utf-8
class Sys::GroupChange::FinancialYear < Sys::GwBase::GwSubDatabase
  include Sys::Model::Base

  set_table_name  :gwsub_sb0904_fiscal_year_settings

#  set_primary_key [:xxxx, :xxx] #dummy
#  set_inheritance_column :dummy
#
#  validates_uniqueness_of :dummy
#  validates_presence_of   :dummy



  def self.get_start_at
    fyears = self.find(:first , :order=>"start_at DESC")
    if fyears.blank?
      return nil
    end
    if fyears.start_at.blank?
      return nil
    end
    if fyears.start_at.strftime("%Y-%m-%d 00:00:00") <= Time.now.strftime("%Y-%m-%d 00:00:00")
      return nil
    end
    return fyears.start_at
  end

end