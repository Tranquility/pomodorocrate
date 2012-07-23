class TodotodaysController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  # GET /dummies
  # GET /dummies.xml
  def index
    @todotodays = Todotoday.where(:today => Date.today).paginate :page => params[:page], :conditions => search_conditions
    #@previous_todotodays =  Todotoday.unscoped.joins(:activity).group("todotodays.activity_id").where(:today => (Time.now.midnight - 7.days)..(Time.now.midnight - 1.day)).where('activities.completed' => false).where(:user_id => current_user.id).order("today DESC, position ASC, todotodays.created_at DESC").limit(5) if @todotodays.empty?
   
   respond_to do |format|
      format.js   {  }
      format.html # index.html.erb
      format.xml  { render :xml => @todotodays.to_xml(:include => [:activity]) }
      format.json { render :json => @todotodays.to_json(:include => [:activity]) }
    end
  end

  # POST /dummies
  # POST /dummies.xml
  def create
    @todotoday = Todotoday.new(:activity_id => params[:activity_id], :today => Date.today, :user_id => current_user.id,
                               :position => ( Todotoday.where(:user_id => current_user.id).count + 1) )

    respond_to do |format|
      if @todotoday.save
        flash[:success] = "Activity has been scheduled for today"
        
        format.html {
          redirect_to(request.env["HTTP_REFERER"]) unless request.xhr?
          render :text => 'OK' if request.xhr?
        }
        format.xml  { render :xml => @todotoday.to_xml(:include => [:activity]), :status => :created, :location => @todotoday }
        format.json { render :json => @todotoday.to_json(:include => [:activity]), :status => :created, :location => @todotoday }
      else
        format.html { redirect_to(activities_path, :error => 'Adding the new todo today has failed') }
        format.xml  { render :xml => @todotoday.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dummies/1
  # DELETE /dummies/1.xml
  def destroy
    @todotoday = Todotoday.where(:user_id => current_user.id).find(params[:id])
    @todotoday.destroy
    
    flash[:success] = "Activity was removed from the todo today list"

    respond_to do |format|
      format.js   { render :text => 'OK' }
      format.html { redirect_to(todotodays_url) }
      format.xml  { head :ok }
      format.json { head :ok }
    end
  end
  
  def save_sort
    params[:act].each_with_index do |activity_id, index|
      Todotoday.where(:activity_id => activity_id, :user_id => current_user.id).first.update_attribute(:position, index + 1)
    end
    
    respond_to do |format|
      format.html { render :nothing => true }
    end
  end

end
