# encoding: utf-8
module Cms::Model::Base::Page
  def states
    [['公開','public'],['非公開','closed']]
  end

  def public_or_preview
    return self if Core.mode == 'preview'
    public
  end

  def public
    self.and "#{self.class.table_name}.state", 'public'
    self.and "#{self.class.table_name}.published_at", 'IS NOT', nil
    self
  end
  
  def public?
    return state == 'public' && published_at
  end

#  def bread_crumbs(crumbs, options = {})
#    return crumbs
#  end
end