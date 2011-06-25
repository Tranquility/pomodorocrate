class ActivitiesController < ApplicationController
  
  before_filter :authenticate
  
  @@per_page = 60
  
  # GET /dummies
  # GET /dummies.xml
  def index
    if params[:q_tags] and params[:q_tags] != 'Tags.' and !params[:q_tags].blank? 
      @activities = Activity.find_tagged_with(params[:q_tags]).paginate :page => params[:page], :conditions => search_conditions
    else
      @activities = Activity.paginate :page => params[:page], :conditions => search_conditions
    end
    
    respond_to do |format|
      format.js     {  }
      format.html   # index.html.erb
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
      redirect_to (activities_url) and return
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

    respond_to do |format|
      if @activity.save
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
        format.html   { redirect_to(activities_path, :success => 'Activity updated.') }
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
    @activity.id = nil
    @activity.deadline = Date.today if @activity.deadline < Date.today
    
    @clone = @activity.clone

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
  
end
