# encoding: utf-8
module Sys::Controller::Scaffold::Base
  def edit
    show
  end

protected
  def _index(items)
    respond_to do |format|
      format.html { render }
      format.xml  { render :xml => items.to_xml(:dasherize => false, :root => 'items') }
    end
  end

  def _show(item)
    return send(params[:do], item) if params[:do]
    respond_to do |format|
      format.html { render }
      format.xml  { render :xml => item.to_xml(:dasherize => false, :root => 'item') }
      format.js { render }
    end
  end

  def _create(item, options = {}, &block)
    if item.creatable? && item.save
      flash[:notice] = options[:notice] || '登録処理が完了しました。'
      status = params[:_created_status] || :created
      options[:location] ||= url_for(:action => :index)
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to options[:location] }
        format.xml  { render :xml => item.to_xml(:dasherize => false), :status => status, :location => url_for(:action => :index) }
      end
    else
      flash.now[:notice] = '登録処理に失敗しました。'
      respond_to do |format|
        format.html { render :action => :new }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def _update(item, options = {}, &block)
    if item.editable? && item.save
      flash[:notice] = '更新処理が完了しました。'
      options[:location] ||= url_for(:action => :index)
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to options[:location] }
        format.xml  { head :ok }
      end
    else
      flash.now[:notice] = '更新処理に失敗しました。'
      respond_to do |format|
        format.html { render :action => :edit }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end

  def _destroy(item, options = {}, &block)
    if item.deletable? && item.destroy
      flash[:notice] = options[:notice] || '削除処理が完了しました。'
      options[:location] ||= url_for(:action => :index)
      yield if block_given?
      respond_to do |format|
        format.html { redirect_to(options[:location]) }
        format.xml  { head :ok }
      end
    else
      flash.now[:notice] = '削除処理に失敗しました。'
      respond_to do |format|
        format.html { render :action => :show }
        format.xml  { render :xml => item.errors, :status => :unprocessable_entity }
      end
    end
  end
end