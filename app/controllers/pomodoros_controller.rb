class PomodorosController < ApplicationController
  
  before_filter :authenticate
  
  include PomodorosHelper
  include BreaksHelper
  
  def index
    @pomodoros = Pomodoro.where(:user_id => current_user.id, :activity_id => params[:activity]).order("created_at DESC")
    
    respond_to do |format|
      unless @pomodoros.empty? 
        format.html { render :layout => false }
        format.xml  { render :xml => @pomodoros }
        format.json { render :json => @pomodoros }
      end
    end
  end
  
  def edit
    @pomodoro = Pomodoro.where(:user_id => current_user.id).find(params[:id])
  end
  
  def show
    redirect_to(activities_path)
  end

  # POST /dummies
  # POST /dummies.xml
  def create
    
    if pomodoro_in_progress?
      unless params[:autocomplete]
        respond_to do |format|
          format.js   { render :text => 'There was a problem contacting the server. Please try to reload the page.', :layout => false and return }
          format.html {
            flash[:error] = "A pomodoro is already in progress"
            redirect_to(activities_path) and return
          }
        end
      end
    end
    
    if break_in_progress?
      unless params[:autocomplete]
        Break.where( :completed => nil ).first.update_attributes(:completed => true)
        @break = nil
      end
    end
    
    @pomodoro = Pomodoro.new(:activity_id => params[:activity_id], :user_id => current_user.id, :duration => current_user.pomodoro_length)
    
    if params[:autocomplete]
      @pomodoro.successful = true
      @pomodoro.completed = true
      @pomodoro.comments = 'Manually marked as completed.'
    end

    respond_to do |format|
      if @pomodoro.save
        format.js   { 
          render :text => 'OK', :layout => false and return if params[:autocomplete]
          render 'widgets/active_pomodoro', :layout => false 
        }
        format.html { redirect_to(todotodays_path, :success => 'The pomodoro was successfully started.') }
        format.xml  { render :xml => @pomodoro, :status => :created, :location => @pomodoro }
        format.json { render :json => @pomodoro, :status => :created, :location => @pomodoro }
      else
        format.js   { render :text => 'KO' }
        format.html { redirect_to(todotodays_path, :error => 'Starting the pomodoro has failed.') }
        format.xml  { render :xml => @pomodoro.errors, :status => :unprocessable_entity }
        format.json { render :json => @pomodoro.errors, :status => :unprocessable_entity }
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
        format.js   { 
          @pomodoro = nil
        }
        format.html { redirect_to(todotodays_path, :notice => 'Pomodoro was successfully updated.') }
        format.xml  { head :ok }
        format.json { head :ok }
      else
        format.js   { render :text => 'KO' }
        format.html { render :action => "edit" }
        format.xml  { render :xml => @pomodoro.errors, :status => :unprocessable_entity }
        format.json { render :json => @pomodoro.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @pomodoro = Pomodoro.find(params[:id])
    current_pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).first
    
    render :text => 'alert("You can not delete the running pomodoro - wait for it to complete or void it, before attempting to delete it.")' and return if @pomodoro == current_pomodoro
    
    if @pomodoro.user_id = current_user.id
      if @pomodoro.destroy
        respond_to do |format|
          format.js {  }  
          format.html { render :text => 'OK' }
          format.xml  { head :ok }
        end
      end
    end
  end
  
  # GET /pomodoros/update_current_form
  def update_current_form
    PomodoroMailer.completed_pomodoro_email(current_user, @pomodoro).deliver if @pomodoro.user.email_notifications
    
    respond_to do |format|
      format.html { render :layout => false }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
  
  # GET /pomodoros/get_time_from_server
  def get_time_from_server    
    @pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).first
    
    respond_to do |format|
      unless @pomodoro.nil?
        format.html { render :layout => false }
      else
        format.html { render :text => '' and return }
      end
    end
  end
  
  # GET /pomodoros/current
  def current
    @pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).first
    
    respond_to do |format|
      unless @pomodoro.nil?
        format.xml  { render :xml => @pomodoro, :status => :created, :location => @pomodoro }
        format.json { render :json => @pomodoro, :status => :created, :location => @pomodoro }
      else
        format.xml  { head :ok }
        format.json { head :ok }
      end
    end
  end
  
end
