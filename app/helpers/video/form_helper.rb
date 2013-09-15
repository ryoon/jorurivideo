# encoding: utf-8
module Video::FormHelper
  def video_category_form(form, options = {})
    item = @template.instance_variable_get("@#{form.object_name}")
    locals = {:f => form, :item => item}.merge(options)
    render :partial => 'video/admin/_partial/categories/form', :locals => locals
  end

  def video_category_view(options = {})
    locals = {:options => options}
    render :partial => 'video/admin/_partial/categories/view', :locals => locals
  end

  def video_skin_form(form, options = {})
    item = @template.instance_variable_get("@#{form.object_name}")
    locals = {:f => form, :item => item}.merge(options)
    render :partial => 'video/admin/_partial/skins/form', :locals => locals
  end

  def video_creator_form(form)
    item = instance_variable_get("@#{form.object_name}")
    locals = {:f => form, :item => item}
    render :partial => 'video/admin/_partial/creators/form', :locals => locals
  end

  def video_creator_view(item, options = {})
    locals = {:item => item}.merge({:options => options})
    render :partial => 'video/admin/_partial/creators/view', :locals => locals
  end


end