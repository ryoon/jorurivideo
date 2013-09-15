module Cms::Controller::Layout
  @skip_layout = nil
  @no_cache    = nil
  
  def render_public_as_string(path, site)
    mode = Core.set_mode('preview')
    
    Page.initialize
    Page.site = site
    Page.uri  = path
    
    begin
      routes = ActionController::Routing::Routes
      node   = Core.search_node(path)
      env    = {}
      opt    = routes.recognize_optimized(node, env)
      ctl    = opt[:controller]
      act    = opt[:action]
      
      opt[:authenticity_token] = params[:authenticity_token] if params[:authenticity_token]
      body   = render_component_as_string :controller => ctl, :action => act, :params => opt
    rescue => e
    end
    
    Core.set_mode(mode) #restore
    
    error = Page.error
    Page.initialize
    
    return error ? nil : body
  end
  
  def render_public_layout
    if Rails.env.to_s == 'production' && !@no_cache
      headers.delete("Cache-Control") #cache on
    end
    
    Page.current_item = Core.current_node unless Page.current_item
    
    return true if @performed_redirect
    return true if @skip_layout
    return true if params[:format] && params[:format] != 'html'
    return true if Page.error
    
    ## content
    content_data = response.body
    
    #response.content_type = nil
    erase_render_results
    reset_variables_added_to_assigns
    @template.instance_variable_set("@content_for_layout", '')
    
    ## concept
    concepts = Cms::Lib::Layout.inhertited_concepts
    
    ## layout
    unless Page.layout = Cms::Lib::Layout.inhertited_layout
      Page.layout = Cms::Layout.new
      return render :text => content_data, :layout => 'layouts/public/base'
    end
    
    body = request.mobile? ? Page.layout.mobile_body.to_s : Page.layout.body.to_s
    
    ## render the piece
    Cms::Lib::Layout.find_design_pieces(body, concepts).each do |name, item|
      Page.current_piece = item
      begin
        next if item.content_id && !item.content
        mnames= item.model.underscore.pluralize.split('/')
        data = render_component_as_string :params => params,
          :controller => mnames[0] + '/public/piece/' + mnames[1], :action => 'index'
        if data =~ /^<html/ && Rails.env.to_s == 'production'
          # component error
        else
          if data.strip != '' && item.model != 'Cms::Free'
            data = %Q(<div#{Page.current_piece.css_attributes}>\n) +
              %Q(<div class="pieceContainer">\n) +
              %Q(<div class="pieceHeader"></div>\n) +
              %Q(<div class="pieceBody">#{data}</div>\n) +
              %Q(<div class="pieceFooter"></div>\n) +
              %Q(</div>\n) +
              %Q(<!-- end .piece --></div>\n)
          end
          body.gsub!("[[piece/#{name}]]", data)
        end
      rescue => e
        #
      end
    end
    
    ## render the content
    body.gsub!("[[content]]", content_data)
    
    ## render the data/text
    Cms::Lib::Layout.find_data_texts(body, concepts).each do |name, item|
      data = item.body
      body.gsub!("[[text/#{name}]]", data)
    end
    
    ## render the data/file
    Cms::Lib::Layout.find_data_files(body, concepts).each do |name, item|
      data = ''
      if item.image_file?
        data = '<img src="' + item.public_uri + '" alt="' + item.title + '" />'
      else
        data = '<a href="' + item.public_uri + '" class="' + item.css_class + '" target="_blank">' + item.united_name + '</a>'
      end
      body.gsub!("[[file/#{name}]]", data)
    end
    
    ## render the emoji
    require 'jpmobile' #v0.0.4
    body.gsub!(/\[\[emoji\/([0-9a-zA-Z\._-]+)\]\]/) do |m|
      name = m.gsub(/\[\[emoji\/([0-9a-zA-Z\._-]+)\]\]/, '\1')
      Cms::Lib::Mobile::Emoji.convert(name, request.mobile)
    end

    ## removes the unknown components
    body.gsub!(/\[\[[a-z]+\/[^\]]+\]\]/, '') #if Core.mode.to_s != 'preview'
    
    ## mobile
    if request.mobile?
      begin
        require 'tamtam'
        body = TamTam.inline(
          :css  => Page.layout.tamtam_css,
          :body => body
        )
      rescue => e #InvalidStyleException
      end
      
      case request.mobile
      when Jpmobile::Mobile::Docomo
        # for docomo
        headers["Content-Type"] = "application/xhtml+xml; charset=utf-8"
      when Jpmobile::Mobile::Au
        # for au
      when Jpmobile::Mobile::Softbank
        # for SoftBank
      when Jpmobile::Mobile::Willcom
        # for Willcom
      else
        # for PC
      end
    end
    
    ## ruby(kana)
    if Page.ruby
      body = Cms::Lib::Navi::Ruby.convert(body)
    end
    
#    ## for preview
#    if Core.mode.to_s == 'preview'
#      body.gsub!(/<a .*?href="\/[^_].*?>/i) do |m|
#        prefix = "/_preview/#{format('%08d', Page.site.id)}"
#        m.gsub(/(<a .*?href=")(\/[^_].*?>)/i, '\1' + prefix + '\2')
#      end
#    end
    
    ## render the true layout
    render :text => body.force_encoding('utf-8'), :layout => 'layouts/public/base'
  end
end
