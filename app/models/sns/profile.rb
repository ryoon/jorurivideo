# encoding: utf-8
class Sns::Profile
#  include Mongoid::Document
#  include Mongoid::Timestamps
#
#  field :name
#  field :sex , :type => Integer
#  field :bloodtype
#  field :birthday, :type => Date, :allow_nil => true
#  field :user_id, :type => Integer
#  field :address
#  field :phone_number
#  field :mobile_number
#  field :mail_addr
#  field :job_skill
#  field :license
#  field :circle
#  field :interest
#  field :thought
#  field :research_group
#  field :self_introduce
#  field :resolution
#  field :program
#  field :photo_path
#
#
#  def sex_select
#    select = [["男性",1],["女性",2]]
#    return select
#  end
#
#  def bloodtype_select
#    select = [["A型","A"],["B型","B"],["AB型","AB"],["O型","O"]]
#    return select
#  end
#
#  def sex_show
#    sex_select.each {|a| return a[0] if a[1] == sex }
#    return nil
#  end
#
#  def bloodtype_show
#    bloodtype_select.each {|a| return a[0] if a[1] == bloodtype }
#    return nil
#  end
#
#  def profile_photo_path
#    if photo_path.blank?
#      path = "/_common/themes/admin/sns/images/sample.jpg"
#    else
#      path = photo_path
#    end
#    return path
#  end

end