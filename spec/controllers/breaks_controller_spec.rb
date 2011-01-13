require 'spec_helper'

describe BreaksController do

  def mock_break(stubs={})
    (@mock_break ||= mock_model(Break).as_null_object).tap do |break|
      break.stub(stubs) unless stubs.empty?
    end
  end

  describe "GET index" do
    it "assigns all breaks as @breaks" do
      Break.stub(:all) { [mock_break] }
      get :index
      assigns(:breaks).should eq([mock_break])
    end
  end

  describe "GET show" do
    it "assigns the requested break as @break" do
      Break.stub(:find).with("37") { mock_break }
      get :show, :id => "37"
      assigns(:break).should be(mock_break)
    end
  end

  describe "GET new" do
    it "assigns a new break as @break" do
      Break.stub(:new) { mock_break }
      get :new
      assigns(:break).should be(mock_break)
    end
  end

  describe "GET edit" do
    it "assigns the requested break as @break" do
      Break.stub(:find).with("37") { mock_break }
      get :edit, :id => "37"
      assigns(:break).should be(mock_break)
    end
  end

  describe "POST create" do

    describe "with valid params" do
      it "assigns a newly created break as @break" do
        Break.stub(:new).with({'these' => 'params'}) { mock_break(:save => true) }
        post :create, :break => {'these' => 'params'}
        assigns(:break).should be(mock_break)
      end

      it "redirects to the created break" do
        Break.stub(:new) { mock_break(:save => true) }
        post :create, :break => {}
        response.should redirect_to(break_url(mock_break))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved break as @break" do
        Break.stub(:new).with({'these' => 'params'}) { mock_break(:save => false) }
        post :create, :break => {'these' => 'params'}
        assigns(:break).should be(mock_break)
      end

      it "re-renders the 'new' template" do
        Break.stub(:new) { mock_break(:save => false) }
        post :create, :break => {}
        response.should render_template("new")
      end
    end

  end

  describe "PUT update" do

    describe "with valid params" do
      it "updates the requested break" do
        Break.should_receive(:find).with("37") { mock_break }
        mock_break.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :break => {'these' => 'params'}
      end

      it "assigns the requested break as @break" do
        Break.stub(:find) { mock_break(:update_attributes => true) }
        put :update, :id => "1"
        assigns(:break).should be(mock_break)
      end

      it "redirects to the break" do
        Break.stub(:find) { mock_break(:update_attributes => true) }
        put :update, :id => "1"
        response.should redirect_to(break_url(mock_break))
      end
    end

    describe "with invalid params" do
      it "assigns the break as @break" do
        Break.stub(:find) { mock_break(:update_attributes => false) }
        put :update, :id => "1"
        assigns(:break).should be(mock_break)
      end

      it "re-renders the 'edit' template" do
        Break.stub(:find) { mock_break(:update_attributes => false) }
        put :update, :id => "1"
        response.should render_template("edit")
      end
    end

  end

  describe "DELETE destroy" do
    it "destroys the requested break" do
      Break.should_receive(:find).with("37") { mock_break }
      mock_break.should_receive(:destroy)
      delete :destroy, :id => "37"
    end

    it "redirects to the breaks list" do
      Break.stub(:find) { mock_break }
      delete :destroy, :id => "1"
      response.should redirect_to(breaks_url)
    end
  end

end
