# -*- coding: utf-8 -*-
module Jpmobile
  module RequestWithMobile

    # 携帯電話からであれば +true+を、そうでなければ +false+ を返す。
    # 常にfalseを返す
    def mobile?
      #mobile != nil
      false
    end

    # 携帯電話の機種に応じて Mobile::xxx を返す。
    # 携帯電話でない場合はnilを返す。
    def mobile
      return nil
      #@__mobile ||= nil
      #return @__mobile if @__mobile

      #Jpmobile::Mobile.carriers.each do |const|
      #  c = Jpmobile::Mobile.const_get(const)
      #  return @__mobile = c.new(self) if c.check_request(self)
      #end
      #nil
    end
  end
end

