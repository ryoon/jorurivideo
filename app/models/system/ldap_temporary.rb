class System::LdapTemporary < Sys::GwBase::GwDatabase
  include Sys::Model::Base
  include Sys::Model::Base::Config

  def synchro_target?
    #return ou =~ /^[0-9]/ ? true : nil
    #return get('givenName') ? true : nil
    return true
  end

  def children
    tmp = self.class.new
    tmp.and :version, version
    tmp.and :parent_id, id
    tmp.and :data_type, 'group'
    return tmp.find(:all,:order=>"code")
  end

  def users
    tmp = self.class.new
    tmp.and :version, version
    tmp.and :parent_id, id
    tmp.and :data_type, 'user'
    return tmp.find(:all,:order=>"code")
  end
end
