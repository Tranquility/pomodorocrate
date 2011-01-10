class TodotodaysController < ApplicationController
  
  # GET /dummies
  # GET /dummies.xml
  def index
    @todotodays = Todotoday.where(:today => Date.today).paginate :page => params[:page]
   
   respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @todotodays }
    end
  end

  # POST /dummies
  # POST /dummies.xml
  def create
    @todotoday = Todotoday.new(:activity_id => params[:activity_id], :today => Date.today)

    respond_to do |format|
      if @todotoday.save
        format.html { redirect_to(todotodays_path, :success => 'Todo today was successfully created.') }
        format.xml  { render :xml => @todotoday, :status => :created, :location => @todotoday }
      else
        format.html { redirect_to(activities_path, :error => 'Adding the new todo today has failed.') }
        format.xml  { render :xml => @todotoday.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  # DELETE /dummies/1
  # DELETE /dummies/1.xml
  def destroy
    @todotoday = Todotoday.find(params[:id])
    @todotoday.destroy
    flash[:success] = "Activity was removed from the todo today list"

    respond_to do |format|
      format.html { redirect_to(todotodays_url) }
      format.xml  { head :ok }
    end
  end

end
