# encoding: utf-8
class Sys::Admin::GroupChangeItemTemporariesController < Sys::Admin::GroupChangeTemporariesController

  def new
    send(params[:do]) if params[:do]
  end

  def confirm
    render :action => :confirm
  end

  def synchronize
    settings = _settings_index
    changes = _changes_index
    _synchronize_data changes, settings

    flash[:notice] = 'コンテンツ変更処理が完了しました。'
    redirect_to :action => :index
  end

  def update
    return error_auth
  end

  def destroy
    return error_auth
  end

protected
  def _create_temporary(changes, settings)
    @log.update_exec_state('preparing', :body =>
      "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- コンテンツ中間データ作成処理が開始されました。")

    # pick up targets
    settings.each do |setting|
      setting[:temp_models].each do |model|
        next if model == 'Sys::GroupChangeGroup'
        temp = eval("#{model}").new
        #temp.pull change, setting
        temp.pull nil, setting
      end
    end

    @log.update_exec_state('prepared', :body =>
      "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- コンテンツ中間データ作成処理が完了しました。", :body_add_type => 'append')
  end

  def _synchronize_data(changes, settings)
    @log.update_exec_state('executing', :body =>
      "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- コンテンツ反映処理が開始されました。")

    # narrow down
    changes.delete_if {|change| !change.temp_group }

    settings.each do |setting|
      @log.update_exec_state('executing', :body =>
        "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- #{setting[:name]} 開始", :body_add_type => 'append')
      setting[:temp_models].each do |model|
        temp = eval("#{model}").new
        temp.synchronize changes, setting
      end
    end
    @log.update_exec_state('completed', :body =>
      "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')} -- コンテンツ処理が処理が完了しました。", :body_add_type => 'append')
  end

end
