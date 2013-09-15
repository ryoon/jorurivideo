# encoding: utf-8
module Video::Controller::Base
  # Scaffold
  def _negate(item, options = {}, &block)
    if item.deletable? && item.save
      flash[:notice] = '論理削除処理が完了しました。'
      options[:location] ||= url_for(:action => :index)
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to options[:location] }
        format.xml  { head :ok }
      end
    else
      flash.now[:notice] = '論理削除処理に失敗しました。'
      respond_to do |format|
        format.html { render :action => :show }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def init_action
    # get help links
    set_help_liks

    # admin setting
    @upper_limit_file_size = Video::AdminSetting.config('upper_limit_file_size')
    @maximum_file_size     = Video::AdminSetting.config('maximum_file_size')
    @maximum_frame_size    = Video::AdminSetting.config('maximum_frame_size')
		@maximum_monthly_report_count = Video::AdminSetting.config('maximum_monthly_report_count')
		
    # monthly
    monthly_group = Video::Clip.new
    @months = monthly_group.find_monthly_groups(:maximum_monthly_report_count => @maximum_monthly_report_count.value.to_i)

    # ranking
    @yesterday   = (Date.strptime(Core.now.match(/^\d{4}-\d{2}-\d{2}/).to_s, "%Y-%m-%d") - 1).to_s
    @a_week_ago  = (Date.strptime(@yesterday, "%Y-%m-%d") - 7).to_s
    @a_month_ago = (Date.strptime(@yesterday, "%Y-%m-%d") - 30).to_s

    # category
    # main category -----------------------
#    group = Video::Clip.new
#    @categories = group.find_category_groups

    # all category support
    cate = Video::Category.new.enabled
    cate.and :parent_id, 0
    cate.order params[:sort], :sort_no
    #@categories = cate.find(:all)
    @categories = []
    cate.find(:all).each do |c|
      @categories << {:id => c.id, :title => c.title, :count => c.has_count(:state => 'public')  }
    end

    # group
    group = Video::Clip.new
    @groups = group.find_creator_groups
  end

  def view_count_mode
    @view_count_mode = Application.config(:view_count_mode, "countup")
    @view_count_mode
  end

  def is_countup_mode?
    view_count_mode unless @view_count_mode
    @view_count_mode == "countup"
  end

  def set_help_liks
    @clip_state_help          = Application.config(:clip_state_help, "/")
    @clip_editting_state_help = Application.config(:clip_editting_state_help, "/")
    @clip_file_help           = Application.config(:clip_file_help, "/")
    @clip_public_url_help     = Application.config(:clip_public_url_help, "/")
  end

end
