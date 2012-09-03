class ActivitiesController < ApplicationController
  
  before_filter :authenticate, :persist_filters_on_session, :load_persisted_settings
  
  @@per_page = 60
  
  # GET /dummies
  # GET /dummies.xml
  def index

    relation = Activity.joins( :project ).where( 'projects.completed' => false )

    if params[:q_tags] and params[:q_tags] != 'Tags.' and !params[:q_tags].blank? 
      @activities = relation.tagged_with(params[:q_tags]).paginate( :page => params[:page], :conditions => search_conditions )
    else
      @activities = relation.paginate( :page => params[:page], :conditions => search_conditions )
    end
    
    respond_to do |format|
      format.js     {  }
      format.html   {  }
      format.xml    { render :xml => @activities }
      format.json   { render :json => @activities }
    end
  end
  
  # GET /dummies/1
  # GET /dummies/1.xml
  def show
    begin
      @activity = Activity.where(:user_id => current_user.id).find(params[:id])
    rescue
      flash[:error] = "There is no activity with id #{params[:id]}"
      
      respond_to do |format|
        format.js   { render :text => 'KO' }
        format.html { redirect_to (activities_url) and return }
      end
      
    end

    respond_to do |format|
      format.js     {  }
      format.html   # show.html.erb
      format.xml    { render :xml => @activity }
      format.json   { render :json => @activity }
    end
  end

  # GET /dummies/new
  # GET /dummies/new.xml
  def new
    @activity = Activity.new
    @activity.project_id = session[:project_id] unless session[:project_id].nil?
    @activity.do_today = false
    
    respond_to do |format|
      format.js     {  }
      format.html   # new.html.erb
      format.xml    { render :xml => @activity }
      format.json   { render :json => @activity }
    end
  end
  
  # POST /dummies
  # POST /dummies.xml
  def create
    @activity = Activity.new(params[:activity])
    @activity.user_id = current_user.id
    
    session[:project_id] = params[:activity][:project_id]

    respond_to do |format|
      if @activity.save

        if @activity.do_today != "0" # why is it not converted to bool? probably because it's virtual attribute
          Todotoday.create( :activity_id => @activity.id, :today => Date.today, :user_id => current_user.id,
                            :position => ( Todotoday.where(:user_id => current_user.id).count + 1) )
        end

        format.html   { redirect_to(@activity, :notice => 'Activity was successfully created.') }
        format.xml    { render :xml => @activity, :status => :created, :location => @activity }
        format.json   { render :json => @activity, :status => :created, :location => @activity }
      else
        format.html   { render :action => "new" }
        format.xml    { render :xml => @activity.errors, :status => :unprocessable_entity }
        format.json   { render :json => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /dummies/1/edit
  def edit
    begin
      @activity = Activity.where(:user_id => current_user.id).find(params[:id])
    rescue
      flash[:error] = "There is no activity with id #{params[:id]}"
      redirect_to (activities_url) and return
    end
    
    respond_to do |format|
      format.js     {  }
      format.html   # new.html.erb
      format.xml    { render :xml => @activity }
      format.json   { render :json => @activity }
    end
  end
  
  # PUT /dummies/1
  # PUT /dummies/1.xml
  def update
    @activity = Activity.where(:user_id => current_user.id).find(params[:id])

    respond_to do |format|
      if params[:activity][:force_update]
        
        params[:activity][:force_update] = nil
        @activity.completed = params[:activity][:completed]
        
        if @activity.save(:validate => false)
          flash[:success] = "Activity updated"
          format.html { redirect_to(request.env["HTTP_REFERER"]) }
          format.xml  { head :ok }
        end
        
      elsif @activity.update_attributes(params[:activity])
        flash[:success] = "Activity updated"
        
        format.js     { render :text => 'OK' }
        format.html   { redirect_to( activities_path , :success => 'Activity updated.') }
        format.xml    { head :ok }
        format.json   { head :ok }
      else
        format.js     { render :text => 'KO' }
        format.html   { render :action => "edit" }
        format.xml    { render :xml => @activity.errors, :status => :unprocessable_entity }
        format.json   { render :json => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dummies/1
  # DELETE /dummies/1.xml
  def destroy
    @activity = Activity.where(:user_id => current_user.id).find(params[:id])
    @activity.destroy
    flash[:success] = "Activity deleted"

    respond_to do |format|
      format.js     { render :text => 'OK' }
      format.html   { redirect_to(activities_url) }
      format.xml    { head :ok }
      format.json   { head :ok }
    end
  end
  
  def clone
    @activity = Activity.where(:user_id => current_user.id).find(params[:id])
    @clone = @activity.dup
    @clone.deadline = Date.today if @clone.deadline < Date.today
    
    respond_to do |format|
      if @clone.save
        format.html   { redirect_to(@clone, :notice => 'Activity cloned') }
        format.xml    { render :xml => @clone, :status => :created, :location => @clone }
        format.json   { render :json => @clone, :status => :created, :location => @clone }
      else
        format.html   { render :action => "new" }
        format.xml    { render :xml => @clone.errors, :status => :unprocessable_entity }
        format.json   { render :json => @clone.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
    def persist_filters_on_session
      
      session[:filtered] = false
      
      if params[:commit]
        
        if params[:q_name] 
          unless params[:q_name].blank?
            if params[:q_name] != "Activity."
              session[:q_name] = params[:q_name]
            else 
              session.delete(:q_name)
            end
          else
            session.delete(:q_name)
          end
        end
        
        if params[:q_project]
          if params[:q_project] != "__none__"
            session[:q_project] = params[:q_project]
          else
            session.delete(:q_project)
          end
        end
        
        if params[:q_completed] 
          if params[:q_completed] != 'All'
            session[:q_completed] = params[:q_completed] 
          else
            session.delete(:q_completed)
          end
        end
        
        if params[:q_tags]
          unless params[:q_tags].blank?
            if params[:q_tags] != 'Tags.'
              session[:q_tags] = params[:q_tags]
            else
              session.delete(:q_tags)
            end
          else
            session.delete(:q_tags)
          end
        end
        
        session.delete(:page)
      end
      
      unless session[:q_name].nil? and session[:q_project].nil? and session[:q_completed].nil? and session[:q_tags].nil?
        session[:filtered] = true
      end
      
      session[:page] = params[:page] if params[:page]
    end
    
    def load_persisted_settings
      params[:q_name] = session[:q_name] if session[:q_name]
      params[:q_project] = session[:q_project] if session[:q_project]
      params[:q_completed] = session[:q_completed] if session[:q_completed]
      params[:q_tags] = session[:q_tags] if session[:q_tags]
      
      params[:page] = session[:page] if session[:page]
    end
  
end
