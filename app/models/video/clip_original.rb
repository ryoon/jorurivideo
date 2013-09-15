# encoding: utf-8
class Video::ClipOriginal < ActiveRecord::Base
  include Sys::Model::Base

  validates_presence_of :clip_id

end
