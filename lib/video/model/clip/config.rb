# encoding: utf-8
module Video::Model::Clip::Config
  def states
    #[['自分のみ','closed'],['特定ユーザ','user'],['特定グループ','group'],['制限なし','public']]
    [['非公開','closed'],['所属公開','group'],['公開','public']]
  end

  def closed
    self.and :state, 'closed'
    self
  end

  def public
    self.and :negated_at, "IS", nil
    self.and :convert_state, 'done'
    self.and Condition.new do |c|
      _c1 = Condition.new
      _c1.and "state", 'group'
      _c1.and "creator_group_id", Core.user_group.id

      _c2 = Condition.new
      _c2.and "state", 'public'

      c.or _c1
      c.or _c2
    end
    return self
  end

  def public?
    self.state == 'public'
  end

#  def public
#    self.and :state, 'public'
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