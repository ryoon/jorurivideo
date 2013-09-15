# encoding: utf-8
class Sys::GwBase::GwDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :gw_core
end