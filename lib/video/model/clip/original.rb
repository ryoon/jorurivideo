# encoding: utf-8
module Video::Model::Clip::Original
  def self.included(mod)
    mod.has_one :original,  :foreign_key => :clip_id,  :class_name => 'Video::ClipOriginal', :dependent => :destroy
    mod.belongs_to :convert_status, :foreign_key => :convert_state,  :class_name => 'Video::Base::Status'

    mod.after_save :set_original
  end

  def set_original
    if self.convert_state == 'queue'
      org = original || Video::ClipOriginal.new

      org.clip_id    = self.id
      org.name       = self.name
      org.mime_type  = self.mime_type
      org.duration   = self.duration
      org.width      = self.width
      org.height     = self.height
      org.size       = self.size
      org.extension  = self.extension
      org.bitrate    = self.bitrate
      org.audio_rate = self.audio_rate
      org.sampling_frequency    = self.sampling_frequency
      org.save
    end
  end
end