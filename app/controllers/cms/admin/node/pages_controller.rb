# encoding: utf-8
class Cms::Admin::Node::PagesController < Cms::Admin::Node::BaseController
  set_model Cms::Model::Node::Page
  
  def edit
    @item = model.new.find(params[:id])
    #return error_auth unless @item.readable?
    
    @item.name ||= 'index.html'
    @item.in_inquiry['state'] ||= 'visible'
    
    _show @item
  end
end
