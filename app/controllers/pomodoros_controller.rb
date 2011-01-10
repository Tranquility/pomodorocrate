class PomodorosController < ApplicationController
  
  include PomodorosHelper
  
  def index
  end
  
  def edit
    @pomodoro = Pomodoro.find(params[:id])
  end
  
  def show
    
  end

  # POST /dummies
  # POST /dummies.xml
  def create
    
    if pomodoro_in_progress?
      flash[:error] = "A pomodoro is already in progress"
      redirect_to(activities_path) and return
    end
    
    @pomodoro = Pomodoro.new(:activity_id => params[:activity_id])

    respond_to do |format|
      if @pomodoro.save
        format.html { redirect_to(todotodays_path, :success => 'The pomodoro was successfully started.') }
        format.xml  { render :xml => @pomodoro, :status => :created, :location => @pomodoro }
      else
        format.html { redirect_to(todotodays_path, :error => 'Starting the pomodoro has failed.') }
        format.xml  { render :xml => @pomodoro.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # PUT /dummies/1
  # PUT /dummies/1.xml
  def update
    @pomodoro = Pomodoro.find(params[:id])

    respond_to do |format|
      if @pomodoro.update_attributes(params[:pomodoro])
        format.html { redirect_to(todotodays_path, :notice => 'Pomodoro was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pomodoro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
  end

end
