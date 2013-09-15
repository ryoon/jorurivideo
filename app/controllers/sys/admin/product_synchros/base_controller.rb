# encoding: utf-8
class Sys::Admin::ProductSynchros::BaseController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
    @version = params[:version_id] || nil
  end

  def index
    if @version.blank?
      @parent = System::Group.find(:first, :conditions=>["id = ?" ,1])
      item = System::Group.new
      item.and :parent_id, @parent.id
      @groups = item.find(:all, :order => 'sort_no, code, id')
    else
      @parent = System::LdapTemporary.new.find(:first,:conditions=>["parent_id = ? and version = ? and data_type = ?", 0, @version, "group"])
      item = System::LdapTemporary.new
      item.and :parent_id, '0'
      item.and :version, @version
      item.and :data_type, 'group'
      @groups = item.find(:all, :order => 'sort_no, code, id')
    end
  end

  def synchronize
    @version = params[:version_id]
    if @version.blank?
      item = System::Group.new
      item.and :state, "enabled"
      item.and "sql", "end_at IS NULL"
      item.and :ldap, 1
      item.and :parent_id, 1
      @items = item.find(:all, :order => 'sort_no, code')
    else
      item = System::LdapTemporary.new
      item.and :version, @version
      item.and :parent_id, 0
      item.and :data_type, 'group'
      @items = item.find(:all, :order => 'sort_no, code')
    end

    unless parent = Sys::Group.find_by_parent_id(0)
      return render :inline => "グループのRootが見つかりません。", :layout => true
    end

    pre_sync

    Sys::Group.update_all("ldap_version = NULL")
    Sys::User.update_all("ldap_version = NULL")

    @results = {:group => 0, :gerr => 0, :user => 0, :uerr => 0, :product => 0, :perr => 0}
    @items.each {|group| do_synchro(group, parent)}

    post_sync

    @results[:udel] = Sys::User.destroy_all("ldap = 1 AND ldap_version IS NULL").size
    @results[:gdel] = Sys::Group.destroy_all("parent_id != 0 AND ldap = 1 AND ldap_version IS NULL").size

    finally_sync

    messages = ["同期処理が完了しました。<br />"]
    messages << "グループ"
    messages << "-- 更新 #{@results[:group]}件"
    messages << "-- 削除 #{@results[:gdel]}件" if @results[:gdel] > 0
    messages << "-- 失敗 #{@results[:gerr]}件" if @results[:gerr] > 0
    messages << "ユーザ"
    messages << "-- 更新 #{@results[:user]}件"
    messages << "-- 削除 #{@results[:udel]}件" if @results[:udel] > 0
    messages << "-- 失敗 #{@results[:uerr]}件" if @results[:uerr] > 0

    flash[:notice] = messages.join('<br />').html_safe

    #redirect_to(:action => :index)
    return_uri = sys_product_synchros_path({:version_id => @version})
    return redirect_to return_uri

  end

protected
  def do_synchro(group, parent = nil)
    ## group
    sg                = Sys::Group.find_by_code(group.code) || Sys::Group.new
    sg_attrs          = sg.attributes

    pre_sync_group sg_attrs, group

    sg.code           = group.code
    sg.parent_id      = parent.id
    sg.state        ||= 'enabled'
    sg.web_state    ||= 'public'
    sg.name           = group.name
    sg.name_en        = group.name_en if !group.name_en.blank?
    sg.email          = group.email   if !group.email.blank?
    sg.level_no       = parent.level_no + 1
    sg.sort_no        = group.sort_no
    sg.ldap         ||= 1
    sg.ldap_version   = @version.blank? ? group.ldap_version : @version;
    sg.group_s_name   = group.group_s_name

    if sg.ldap == 1
      g_saved = sg.save(:validate => false)
      if g_saved
        @results[:group] += 1
      else
        @results[:gerr] += 1
      end

      post_sync_group g_saved, sg_attrs, sg

      return false unless g_saved
    end

    ## users
    if group.users.size > 0
      group.users.each do |user|
        su                   = Sys::User.find_by_account(user.code) || Sys::User.new
        su_attrs             = su.attributes

        pre_sync_user su_attrs, user, sg_attrs, sg

        su.account           = user.code
        su.state           ||= 'enabled'
        su.auth_no         ||= 2
        su.name              = user.name
        su.name_en           = user.name_en
        su.email             = user.email
        su.kana              = user.kana if @version.blank?
        su.ldap            ||= 1
        su.ldap_version      = @version.blank? ? user.ldap_version : @version;
        su.sort_no           = user.sort_no
        su.in_group_id       = sg.id
        su.official_position = user.offitial_position
        su.assigned_job      = user.assigned_job
        su.mobile_access     = user.mobile_access   if @version.blank?
        su.mobile_password   = user.mobile_password if @version.blank?
        if su.ldap == 1
          u_saved = su.save
          if u_saved
            @results[:user] += 1
          else
            @results[:uerr] += 1
          end
          post_sync_user u_saved, su_attrs, su, sg_attrs, sg
        end
      end
    end

    ## next
    if group.children.size > 0
      group.children.each {|g| do_synchro(g, sg)}
    end
  end

  # overridable ----------------------------------------------------
  def pre_sync( options={} )
    true
  end

  def post_sync( options={} )
    true
  end

  def finally_sync( options={} )
    true
  end


  def pre_sync_group(current_attrs, group, options={} )
    true
  end

  def post_sync_group(saved, pre_attrs, group, options={} )
    true
  end

  def pre_sync_user(current_user_attrs, user, current_group_attrs, group, options={} )
    true
  end

  def post_sync_user(saved, pre_user_attrs, user, pre_group_attrs, group, options={} )
    true
  end

end
