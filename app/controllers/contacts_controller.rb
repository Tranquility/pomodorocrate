# this one is used in the site, outside the app
class ContactsController < ApplicationController
  
  layout 'static'
  
  def index
    @contact = Contact.new
  end
  
  def create
    @contact = Contact.new(params[:contact])
    
    respond_to do |format|
      if verify_recaptcha(:model => @contact, :message => 'Please re-enter the words from the image again.') and @contact.save
        
        ContactMailer.contact_request_from_site(@contact).deliver
        
        format.html { redirect_to(contacts_path, :notice => 'Your message has been sent. Thank you!') }
        format.xml  { render :xml => @contact, :status => :created, :location => @contact }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @contact.errors, :status => :unprocessable_entity }
      end
    end
    
  end
  
end
