# this one is used in the app, for feedback
class ContactRequestsController < ApplicationController
  
  before_filter :authenticate

  # GET /contact_requests
  # GET /contact_requests.xml
  
  layout "modal"
  
  def index
    @contact_requests = ContactRequest.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @contact_requests }
    end
  end

  # GET /contact_requests/1
  # GET /contact_requests/1.xml
  def show
    @contact_request = ContactRequest.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @contact_request }
    end
  end

  # GET /contact_requests/new
  # GET /contact_requests/new.xml
  def new
    @contact_request = ContactRequest.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @contact_request }
    end
  end

  # GET /contact_requests/1/edit
  def edit
    @contact_request = ContactRequest.find(params[:id])
  end

  # POST /contact_requests
  # POST /contact_requests.xml
  def create
    @contact_request = ContactRequest.new(params[:contact_request])
    @contact_request.user = current_user

    respond_to do |format|
      if @contact_request.save
        flash[:success] = 'Your message has been sent. Thank you!'
        
        ContactMailer.contact_request(@contact_request).deliver
        
        format.html { redirect_to(@contact_request) }
        format.xml  { render :xml => @contact_request, :status => :created, :location => @contact_request }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @contact_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /contact_requests/1
  # PUT /contact_requests/1.xml
  def update
    @contact_request = ContactRequest.find(params[:id])

    respond_to do |format|
      if @contact_request.update_attributes(params[:contact_request])
        format.html { redirect_to(@contact_request, :success => 'Your message has been updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @contact_request.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /contact_requests/1
  # DELETE /contact_requests/1.xml
  def destroy
    @contact_request = ContactRequest.find(params[:id])
    @contact_request.destroy

    respond_to do |format|
      format.html { redirect_to(contact_requests_url) }
      format.xml  { head :ok }
    end
  end
end
