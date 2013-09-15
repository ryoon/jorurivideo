# encoding: utf-8
module Video::Model::Clip::EdittingGroup
  def self.included(mod)
    mod.belongs_to :editting_status, :foreign_key => :editting_state,  :class_name => 'Video::Base::Status'
    mod.validate :validate_editting_group
  end

  def validate_editting_group
    #Core.user.has_auth?(:manager)
    if self.editting_group_ids.blank?
      self.editting_group_ids = self.creator_group_id
      self.editting_group_ids = Core.user_group.id if self.editting_group_ids.blank?
    else
      self.editting_group_ids = self.creator_group_id unless self.editting_group_ids == self.creator_group_id
    end
  end

  def editting_states
    #[['自分のみ','my'],['特定ユーザ','users'],['特定グループ','shared'],['制限なし','unlimited']]
    [['マイ動画','private'],['所属動画','shared']]
  end


  def mine
    self.and Condition.new do |c|
      c.and "editting_state", 'private'
      c.and "creator_id", Core.user.id
    end
    return self
  end

  def shared
    self.and Condition.new do |c|
      c.and "editting_state", 'shared'
      c.and "editting_group_ids", 'REGEXP', "(^| )#{Core.user_group.id}( |$)"
    end
    return self
  end

  def editable
    self.and Condition.new do |c|
      _c1 = Condition.new
      _c1.and "editting_state", 'private'
      _c1.and "creator_id", Core.user.id

      _c2 = Condition.new
      _c2.and "editting_state", 'shared'
      _c2.and "editting_group_ids", 'REGEXP', "(^| )#{Core.user_group.id}( |$)"

      c.or _c1
      c.or _c2
    end
    return self
  end

  def creatable?
    return false unless Core.user.has_auth?(:creator)
    return true
  end

  def editable?
    return true if Core.user.has_auth?(:manager)
    return false unless self.negated_at.blank?
    return true if self.editting_state == 'private' && self.creator_id == Core.user.id
    return true if self.editting_state == 'shared' && self.editting_group_ids =~ /(^| )#{Core.user_group.id}( |$)/
    return true if @stayed_attributes && @stayed_attributes[:editting_state] == 'shared' && @stayed_attributes[:editting_group_ids] =~ /(^| )#{Core.user_group.id}( |$)/

    return false
  end

  def deletable?
    editable?
  end

  def shared?
    self.editting_state == 'shared'
  end

  def sharable?
    shared? && editting_group_ids =~ /(^| )#{Core.user_group.id}( |$)/
  end

  def private?
    self.editting_state == 'private'
  end

  def mine?
    private? && creator_id == Core.user.id
  end



#  def edditting_user
#    self.and :state, 'user'
#    self
#  end
#
#  def edditting_group
#    self.and :state, 'group'
#    self
#  end

#  def enabled?
#    return state == 'enabled'
#  end
#
#  def disabled?
#    return state == 'disabled'
#  end
end