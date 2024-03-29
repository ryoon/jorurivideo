# encoding: utf-8
class Cms::Admin::Tool::RebuildController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  
  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:designer)
  end
  
  def index
    @item = Cms::Node.new(params[:item])
    if params[:do] == 'content'
      Core.messages << "再構築： コンテンツ"
      
      item = Cms::Content.new
      item.and :model, 'Article::Doc'
      item.and :id, @item.content_id if !@item.content_id.blank?
      items = item.find(:all)
      items.each do |item|
        ctl = item.model.underscore.pluralize.gsub(/^(.*?)\//, '\1/admin/tool/')
        act = 'rebuild'
        prm = params.merge({:content => item})
        begin
          Core.messages << "#{item.name}"
          res = render_component_as_string :controller => ctl, :action => act, :params => prm
        rescue => e
          Core.messages << "-- Error #{e}"
        end
      end
      
    elsif params[:do] == 'styleseet'
      Core.messages << "再構築： スタイルシート"
      
      results = [0, 0]
      item = Cms::Layout.new
      item.and :concept_id, @item.concept_id if !@item.concept_id.blank?
      items = item.find(:all)
      items.each do |item|
        begin
          if item.put_css_files
            results[0] += 1
          end
        rescue => e
          results[1] += 1
        end
      end
      
      Core.messages << "-- 成功 #{results[0]}件"
      Core.messages << "-- 失敗 #{results[1]}件"
    end
    
    if !Core.messages.empty?
      flash[:notice] = "再構築が終了しました。<br />#{Core.messages.join('<br />')}".html_safe
      redirect_to :action => :index
    end
  end
end
