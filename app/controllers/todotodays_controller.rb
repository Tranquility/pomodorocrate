class TodotodaysController < ApplicationController
  
  before_filter :authenticate
  #before_filter :correct_user
  
  # GET /dummies
  # GET /dummies.xml
  def index
    @todotodays = Todotoday.where(:today => Date.today).paginate :page => params[:page], :conditions => search_conditions
   
   respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @todotodays.to_xml(:include => [:activity]) }
      format.json { render :json => @todotodays.to_json(:include => [:activity]) }
    end
  end

  # POST /dummies
  # POST /dummies.xml
  def create

    if Todotoday.where(:user_id => current_user.id).count > 0 
      position = Todotoday.where(:user_id => current_user.id).count + 1
    else 
      position = 1
    end
    
    @todotoday = Todotoday.new(:activity_id => params[:activity_id], :today => Date.today, :user_id => current_user.id, :position => position)

    respond_to do |format|
      if @todotoday.save
        flash[:success] = "Activity has been scheduled for today"
        
        format.html { redirect_to(request.env["HTTP_REFERER"]) }
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
