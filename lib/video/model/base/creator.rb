# encoding: utf-8
module Video::Model::Base::Creator

  def self.included(mod)
    mod.belongs_to :creator,       :foreign_key => 'creator_id',       :class_name => 'Video::Base::User'
    mod.belongs_to :creator_group, :foreign_key => 'creator_group_id', :class_name => 'Video::Base::Group'

    mod.validate :validate_creator
  end

  def validate_creator
    #Core.user.has_auth?(:manager)

    # must
    self.creator_group_id = Core.user.group.id if self.creator_group_id.blank?

    # private
    #self.creator_id = Core.user.id if self.creator_id.blank? && private? && Core.user
    if private?
      if Core
        self.creator_id = Core.user.id               if self.creator_id.blank? && Core.user
        self.creator_group_id = Core.user.group.id   if Core.user_group && Core.user_group.id != self.creator_group_id && Core.user.has_auth?(:manager)
      end
    end

    # change creator
    if @stayed_attributes && @stayed_attributes[:editting_state] == 'shared' && @stayed_attributes[:editting_group_ids] =~ /(^| )#{Core.user_group.id}( |$)/
      self.creator_id = Core.user.id if !Core.user.has_auth?(:manager)
    end if Core.user_group && Core.user

    # general
    if self.creator_id.blank? && Core && Core.user_group && Core.user
      self.creator_id = Core.user.id if !Core.user.has_auth?(:manager)
    end
  end
end
