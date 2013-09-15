# encoding: utf-8
class Sys::GwBase::GwSubDatabase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection :gw_sub
end