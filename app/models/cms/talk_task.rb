class Cms::TalkTask < ActiveRecord::Base
  include Sys::Model::Base
  
  belongs_to :site,   :foreign_key => :site_id,  :class_name => 'Cms::Site'
  
  validates_presence_of :site_id, :path, :uri
  
  before_save :set_regular
  
  def self.add(params)
    site_id = params[:site_id] || Core.site.id
    cond = {:site_id => site_id, :uri => params[:uri]}
    return false if Cms::TalkTask.find(:first, :conditions => cond)
    
    task = Cms::TalkTask.new
    task.site_id    = site_id
    task.content_id = params[:content_id]
    task.controller = params[:controller]
    task.path       = params[:path].gsub(/^#{Rails.root.to_s}/, '.')
    task.uri        = params[:uri]
    task.regular    = params[:regular] || 2
    task.save
  end
  
  def content_path
    path = self.path
    path = File.join(Rails.root, path) if path.slice(0, 1) != '/'
    if path.slice(path.size - 1, 1) == '/'
      return path + 'index.html'
    end
    return path
  end
  
  def content_uri
    File.join(site.publish_uri, uri)
  end
  
  def sound_path
    if content_path.slice(content_path.size - 1, 1) == '/'
      return content_path + 'index.html.mp3'
    end
    return content_path + '.mp3'
  end
  
  def read_content
    content = nil
    if FileTest.exist?(content_path)
      content = File.new(content_path).read
    elsif content_uri.to_s != ''
      res = Util::Http::Request.send(content_uri)
      return nil if res.status != 200
      #content = res[:body]
      
      begin
        xml = REXML::Document.new(res.body)
        content = xml.elements['data'].elements['page_data'].text
      rescue
        return nil
      end
    end
    return Cms::Lib::Navi::Gtalk.make_text(content)
  end
  
  def make_sound(content)
    gtalk = Cms::Lib::Navi::Gtalk.new
    if gtalk.make content
      self.result = 'success'
    else
      self.result = 'error'
    end
    
    gtalk.output
  end
  
  def terminate
    if regular == 1
      save
    else
      destroy
    end
  end
  
private
  def set_regular
    self.regular ||= 2
  end
end
