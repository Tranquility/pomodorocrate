class InterruptionsController < ApplicationController
  
  before_filter :authenticate
  
  include PomodorosHelper
  
  # POST /dummies
  # POST /dummies.xml
  def create
    
    unless pomodoro_in_progress?
      flash[:error] = "There is no active Pomodoro to be interrupted"
      redirect_to(activities_path) and return
    end
    
    pomodoro = Pomodoro.where( :completed => nil, :user_id => current_user.id ).last
    @interruption = Interruption.new( :kind => params[:kind], :pomodoro_id => pomodoro.id, :user_id => current_user.id )

    respond_to do |format|
      if @interruption.save
        #flash[:success] = "The #{@interruption.kind} interruption has been recorded."
        @interruptions_count = (pomodoro.interruptions.nil? or pomodoro.interruptions.blank?) ? 0 : pomodoro.interruptions.find_all_by_kind(@interruption.kind).count
        
        format.js   {  }
        format.html {
          flash[:success] = "The #{@interruption.kind} interruption has been recorded."
          redirect_to(todotodays_path)
        }
        format.xml  { render :xml => @interruption, :status => :created, :location => @interruption }
      else
        flash[:error] = "The #{@interruption.kind} interruption recording has failed."
        
        format.html { redirect_to(todotodays_path) }
        format.xml  { render :xml => @interruption.errors, :status => :unprocessable_entity }
      end
    end
  end

end
