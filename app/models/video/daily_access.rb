class Video::DailyAccess < ActiveRecord::Base
  include Sys::Model::Base
  #include Video::Model::Clip::Log
  include Video::Lib::Log

#  def blank_gif
#    #file = File.new('blank.gif')
#    #data = file.read
#    #data = data.unpack("H*")
#    [
#      '47494638396101000100800000ffffff00000021f90401000000002c00000000010001000002024401003b'
#    ].pack("H*")
#  end


########################################################
## admin side

  def find_total(options={})
    result = {}
    return result unless content
    #return result unless @from_date
    case @range
      when 'hoge'
      else
        result[:total] = self.class.find(:first , :select => "sum(count) AS summary_count, content",
                                 :conditions => ["content = ? AND item_id = ?",  content, options[:id]])
    end
    return result
  end


#  def yearly
#    @range = 'yearly'
#    return self
#  end
#
#  def monthly
#    @range = 'monthly'
#    return self
#  end
#
#  def get_from_date
#    @from_date
#  end
#
#  def get_to_date
#    @to_date
#  end
#
#  def set_summary_range(view_mode=nil, from=nil, to=nil, options={})
#    return self unless view_mode
#    return self unless from
#    return self unless @range
#
#    @from_date = from[:s_date]
#
#    case @range
#      when 'yearly'
#        @to_date = Date.new(@from_date.year, 12, 31)
#        self.and :accessed_at, ">=", @from_date.strftime('%Y-01-01')
#        self.and :accessed_at, "<=", @to_date.strftime('%Y-%m-%d')
#
#      when 'monthly'
#        @to_date = ((from[:s_date] >> 1) -1)
#        self.and :accessed_at, ">=", @from_date.strftime('%Y-%m-01')
#        self.and :accessed_at, "<=", @to_date.strftime('%Y-%m-%d')
#    end
#  end
#
#
#  def find_accesses(*args)
#    scope     = args.slice!(0)
#    view_mode = args.slice!(0)
#    #options   = args.slice!(0) || {}
#
#    result = []
#    if view_mode == 'subject'
#       result = find(scope , :select => "sum(count) AS smy, item_id",
#                             :group => "item_id", :order => "smy DESC")
#    else
#      result = case @range
#                 when 'monthly'
#                     find(scope , :select => "accessed_at, sum(count) as smy",
#                                  :group => "accessed_at", :order => "accessed_at")
#
#                 when 'yearly'
#                     find(scope , :select => "month(accessed_at) as mth, sum(count) as smy",
#                                  :group => "month(accessed_at)", :order => "mth")
#               end
#    end
#    return result
#  end
#
#  def find_total(*args)
#    result = {}
#    return result unless content
#    return result unless @from_date
#    case @range
#      when 'monthly'
#        from_date = @from_date.strftime('%Y-%m-01')
#        to_date =  @to_date ? @to_date.strftime('%Y-%m-%d') : @to_date = ((@from_date >> 1) -1).strftime('%Y-%m-%d')
#
#        result[:monthly_total] = self.class.find(:first , :select => "sum(count) AS smy, content",
#                                 :conditions => ["content = ? AND accessed_at >= ? AND accessed_at <= ?",  content, from_date, to_date],
#                                 :group => "content", :order => "smy DESC")
#
#      when 'yearly'
#        from_date = @from_date.strftime('%Y-01-01')
#        to_date   = @from_date.strftime('%Y-12-31')
#        result[:yearly_total] = self.class.find(:first , :select => "sum(count) AS smy, content",
#                                 :conditions => ["content = ? AND accessed_at >= ? AND accessed_at <= ?",  content, from_date, to_date],
#                                 :group => "content", :order => "smy DESC")
#    end
#    return result
#  end

end
