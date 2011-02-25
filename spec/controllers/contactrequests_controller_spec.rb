require 'spec_helper'

describe ContactrequestsController do

  def mock_contactrequest(stubs={})
    (@mock_contactrequest ||= mock_model(Contactrequest).as_null_object).tap do |contactrequest|
      contactrequest.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all contactrequests as @contactrequests" do
      Contactrequest.stub(:all) { [mock_contactrequest] }
      get :index
      assigns(:contactrequests).should eq([mock_contactrequest])
    end
  end

  describe "GET show" do
    it "assigns the requested contactrequest as @contactrequest" do
      Contactrequest.stub(:find).with("37") { mock_contactrequest }
      get :show, :id => "37"
      assigns(:contactrequest).should be(mock_contactrequest)
    end
  end

  describe "GET new" do
    it "assigns a new contactrequest as @contactrequest" do
      Contactrequest.stub(:new) { mock_contactrequest }
      get :new
      assigns(:contactrequest).should be(mock_contactrequest)
    end
  end

  describe "GET edit" do
    it "assigns the requested contactrequest as @contactrequest" do
      Contactrequest.stub(:find).with("37") { mock_contactrequest }
      get :edit, :id => "37"
      assigns(:contactrequest).should be(mock_contactrequest)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created contactrequest as @contactrequest" do
        Contactrequest.stub(:new).with({'these' => 'params'}) { mock_contactrequest(:save => true) }
        post :create, :contactrequest => {'these' => 'params'}
        assigns(:contactrequest).should be(mock_contactrequest)
      end

      it "redirects to the created contactrequest" do
        Contactrequest.stub(:new) { mock_contactrequest(:save => true) }
        post :create, :contactrequest => {}
        response.should redirect_to(contactrequest_url(mock_contactrequest))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved contactrequest as @contactrequest" do
        Contactrequest.stub(:new).with({'these' => 'params'}) { mock_contactrequest(:save => false) }
        post :create, :contactrequest => {'these' => 'params'}
        assigns(:contactrequest).should be(mock_contactrequest)
      end

      it "re-renders the 'new' template" do
        Contactrequest.stub(:new) { mock_contactrequest(:save => false) }
        post :create, :contactrequest => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested contactrequest" do
        Contactrequest.should_receive(:find).with("37") { mock_contactrequest }
        mock_contactrequest.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :contactrequest => {'these' => 'params'}
      end

      it "assigns the requested contactrequest as @contactrequest" do
        Contactrequest.stub(:find) { mock_contactrequest(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:contactrequest).should be(mock_contactrequest)
      end

      it "redirects to the contactrequest" do
        Contactrequest.stub(:find) { mock_contactrequest(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(contactrequest_url(mock_contactrequest))
      end
    end

    describe "with invalid params" do
      it "assigns the contactrequest as @contactrequest" do
        Contactrequest.stub(:find) { mock_contactrequest(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:contactrequest).should be(mock_contactrequest)
      end

      it "re-renders the 'edit' template" do
        Contactrequest.stub(:find) { mock_contactrequest(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested contactrequest" do
      Contactrequest.should_receive(:find).with("37") { mock_contactrequest }
      mock_contactrequest.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the contactrequests list" do
      Contactrequest.stub(:find) { mock_contactrequest }
      delete :destroy, :id => "1"
      response.should redirect_to(contactrequests_url)
    end
  end

end
