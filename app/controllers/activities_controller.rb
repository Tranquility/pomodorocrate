class ActivitiesController < ApplicationController

  # GET /dummies
  # GET /dummies.xml
  def index
    @activities = Activity.paginate :page => params[:page]
  end
  
  # GET /dummies/1
  # GET /dummies/1.xml
  def show
    begin
      @activity = Activity.find(params[:id])
    rescue
      flash[:error] = "There is no activity with id #{params[:id]}"
      redirect_to (activities_url) and return
    end

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @activity }
    end
  end

  # GET /dummies/new
  # GET /dummies/new.xml
  def new
    @activity = Activity.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @activity }
    end
  end
  
  # POST /dummies
  # POST /dummies.xml
  def create
    @activity = Activity.new(params[:activity])

    respond_to do |format|
      if @activity.save
        format.html { redirect_to(@activity, :notice => 'Activity was successfully created.') }
        format.xml  { render :xml => @activity, :status => :created, :location => @activity }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end

  # GET /dummies/1/edit
  def edit
    @activity = Activity.find(params[:id])
  end
  
  # PUT /dummies/1
  # PUT /dummies/1.xml
  def update
    @activity = Activity.find(params[:id])

    respond_to do |format|
      if @activity.update_attributes(params[:activity])
        format.html { redirect_to(@activity, :notice => 'Activity was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @activity.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dummies/1
  # DELETE /dummies/1.xml
  def destroy
    @activity = Activity.find(params[:id])
    @activity.destroy
    flash[:success] = "Activity deleted"

    respond_to do |format|
      format.html { redirect_to(activities_url) }
      format.xml  { head :ok }
    end
  end
  

end
