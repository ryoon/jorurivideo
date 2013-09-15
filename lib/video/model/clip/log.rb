# encoding: utf-8
module Video::Model::Clip::Log

  def access_count(mode="countup", options={})
    return 0 unless self.id
    return self.view_count || 0 if mode == "countup" || mode == "both"

    item = Video::DailyAccess.new(:content => 'video')
    result = item.find_total( {:id => self.id})

    summary_count = 0
    summary_count = result[:total][:summary_count] if result[:total]
    return  summary_count || 0
  end

end