class Video::Script::AccessLogsController < ApplicationController
  def self.count
    content  = 'video'
    date     = Date.today - 1 # Date.new(2011, 8, 2)  #TODO:test
    aclog    = Video::DailyAccess.new(:content => content)
    log_file = aclog.log_file(:time => date)

    begin
      ## read log
      paths  = {}
      counts = {}
      if FileTest.exist?(log_file)
        #require 'fastercsv'
        #FasterCSV.foreach(log_file) do |data|
        require 'csv'
        CSV.foreach(log_file) do |data|
          ## data = [0:date, 1:path, 2:content, 3:id, 4:ipaddr]
          next unless data[1]
          id = data[3]
          if counts[id]
            counts[id] += 1
          else
            counts[id] = 1
          end
          paths[id] = data[1]
        end
      end

      ## Resets the table
      Video::DailyAccess.delete_all(['content = ? AND accessed_at = ?', content, date])

      ## Updates the table
      if counts.size == 0
        ac = Video::DailyAccess.new(:content => content, :accessed_at => date)
        ac.item_id = 0
        ac.count   = 0
        ac.path    = ''
        ac.save
      else
        counts.each do |count|
          ac = Video::DailyAccess.new(:content => content, :accessed_at => date)
          ac.item_id = count[0]
          ac.count   = count[1]
          ac.path    = paths[ac.item_id.to_s]
          ac.save
        end
      end
    rescue => e
      puts "Error: #{e}"
    end
    #render :text => "OK"
  end


#  def exec
#    task = Sys::Task.new
#    task.and :process_at, '<=', Time.now + (60 * 5) # before 5 min
#    tasks = task.find(:all, :order => :process_at)
#
#    if tasks.size == 0
#      return render :text => "No Tasks"
#    end
#
#    tasks.each do |task|
#      begin
#        unless unid = task.unid_data
#          task.destroy
#          raise 'Unid No Found'
#        end
#
#        model = unid.model.underscore.pluralize
#        item  = eval(unid.model).find_by_unid(unid.id)
#        res   = render_component_as_string :controller => model.gsub(/^(.*?)\//, '\1/script/'),
#          :action => task.name, :params => {:unid => unid, :item => item}
#        if res =~ /^OK/i
#          task.destroy
#        end
#      rescue => e
#        puts "Error: #{e}"
#      end
#    end
#
#    render :text => "OK"
#  end
end
