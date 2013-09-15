# encoding: utf-8
class Sys::Admin::GroupChanges::ImportController < Cms::Controller::Admin::Base
  include Sys::Controller::Scaffold::Base
  require 'csv'

  def pre_dispatch
    return error_auth unless Core.user.has_auth?(:manager)
  end

  def index
  end

  def import
    @results = [0, 0, 0]

    if params[:do] == 'gw_group_changes'
      Core.messages << "--------------------------------"
      Core.messages << "インポート： Gw組織変更データ"

      # clear
      clear_group_changes
      # import
      success = import_gw_group_changes
    else
      return redirect_to(:action => :index)
    end
    Core.messages << "--------------------------------"
    Core.messages << "-- 追加     #{@results[0]}件"
    Core.messages << "-- スキップ #{@results[1]}件"
    Core.messages << "-- 失敗     #{@results[2]}件"
    Core.messages << "--------------------------------"

    flash[:notice] = "インポートが終了しました。<br />#{Core.messages.join('<br />')}".html_safe
    return redirect_to(:action => :index)
  end


  def import_gw_group_changes

    start_at = Sys::GroupChange::FinancialYear.get_start_at
    if start_at.blank?
      Core.messages << "error Gwの設定が不正です。"
      return false
    end

    #start_date = start_at.strftime('%Y-%m-%d')
    start_time = start_at.strftime('%Y-%m-%d 00:00:00')


    # select gw database (updates, nexts)
    p = Sys::GroupChange::Plan.new
    p.and :start_at, start_time
    plans = p.find(:all)
    plans.each do |plan|
      existences = plan.existences
      if existences && existences.size > 0
        # 引継ぎ元がある場合 → 移動 or 統合
        existences.each do |ex|
          current = Sys::Group.find(:first, :conditions => {:code => ex.old_code, :name => ex.old_name } )
          unless current
            @results[2] += 1
            Core.messages << "no exist #{ex.old_code}:#{ex.old_name}"
            next
          end

          gchg = Sys::GroupChange.new({
            :code              => plan.code,
            :name              => plan.name,
            :level_no          => plan.level_no,
            :parent_code       => plan.parent_code,
            :parent_name       => plan.parent_name,
            :change_division   => (plan.integrate_state? || existences.size > 1) ? 'integrate' : 'move',
            :ldap              => 1,   # TODO:
            :start_date        => nil,
            :old_division      => nil,
            :old_id            => current.id,
            :old_code          => current.code,
            :old_name          => current.name,
            :commutation_code  => nil,
          })
          begin
            gchg.save(false)
            @results[0] += 1
          rescue
            #dump org.attributes
            @results[2] += 1
            Core.messages << "error #{ex.old_code}:#{ex.old_name}"
          end
        end

      else
        # 無い場合 → 新設、or 廃止
        # ステータスが、廃止で、(existencesに存在すれば、移動 or 統合なので、スルー)
        own_plans = plan.own_plans
        unless plan.dismantle_state? && own_plans && own_plans.size > 0
          gchg = Sys::GroupChange.new({
            :code              => plan.code,
            :name              => plan.name,
            :level_no          => plan.level_no,
            :parent_code       => plan.parent_code,
            :parent_name       => plan.parent_name,
            :change_division   => plan.dismantle_state? ? 'dismantle' : 'add',
            :ldap              => 1,   # TODO:
            :start_date        => nil,
            :old_division      => nil,
            :old_id            => nil,
            :old_code          => nil,
            :old_name          => nil,
            :commutation_code  => nil,
          })
          begin
            gchg.save(false)
            @results[0] += 1
          rescue
            @results[2] += 1
            Core.messages << "error #{plan.code}:#{plan.name}"
          end
        else
          @results[1] += 1
          Core.messages << "skip #{plan.code}:#{plan.name}"
        end
      end
    end
    return true
  end

  def clear_group_changes
    Sys::GroupChange.new.truncate_table
    Sys::GroupChangeGroup.new.truncate_table
    Sys::GroupChangeItem.new.truncate_table
  end

end
