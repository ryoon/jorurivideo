# encoding: utf-8
module Video::Lib::Log
  def log_file(options = {})
    return false unless self.content

    time     = options[:time] || Time.now
    date     = time.strftime('%Y/%m/%d/')
    content  = self.content
    content  = sprintf('%08d', content) if content.to_s =~ /^[0-9]+$/
    log_file = RAILS_ROOT + '/log/access/' + date + content + '.log'
  end

  def puts_log(message, options = {})
    unless log = log_file(options)
      return false
    end
    dir = File.dirname(log)
    FileUtils.mkdir_p(dir) unless FileTest.exist?(dir)

    f = File.open(log, 'a')
    f.flock(File::LOCK_EX)
    f.puts message
    f.flock(File::LOCK_UN)
    f.close
  end
end