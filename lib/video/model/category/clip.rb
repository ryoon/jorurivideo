# encoding: utf-8
module Video::Model::Category::Clip

  def has_count(options={})
    return  0 if self.state == 'disabled'
    clip = Video::Clip.new
    # condition
    clip.public if options[:state] && options[:state] == 'public'
    clip.category_is(self)
    _count = clip.find(:first , :select => "count(*) as cnt")
    return _count.cnt
  end

end