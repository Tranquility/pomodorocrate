class PomodorosController < ApplicationController
  
  before_filter :authenticate
  
  include PomodorosHelper
  include BreaksHelper
  
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
    
    if break_in_progress?
      Break.where( :completed => nil ).first.update_attributes(:completed => true)
    end
    
    @pomodoro = Pomodoro.new(:activity_id => params[:activity_id], :user_id => current_user.id, :duration => current_user.pomodoro_length)

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
    @pomodoro = Pomodoro.where(:user_id => current_user.id).find(params[:id])

    respond_to do |format|
      if @pomodoro.update_attributes(params[:pomodoro])
        
        #if(params[:pomodoro][:successful] == true)
        #  PomodoroMailer.successful_pomodoro_email(current_user, @pomodoro).deliver
        #else
        #  PomodoroMailer.voided_pomodoro_email(current_user, @pomodoro).deliver
        #end
        
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
  
  # GET /pomodoros/update_current_form
  def update_current_form
    PomodoroMailer.completed_pomodoro_email(current_user, @pomodoro).deliver if @pomodoro.user.email_notifications
    
    respond_to do |format|
      format.html { render :layout => false }
    end
  end
  
end
