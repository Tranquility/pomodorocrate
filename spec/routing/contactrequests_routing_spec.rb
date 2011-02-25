require "spec_helper"

describe ContactrequestsController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/contactrequests" }.should route_to(:controller => "contactrequests", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/contactrequests/new" }.should route_to(:controller => "contactrequests", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/contactrequests/1" }.should route_to(:controller => "contactrequests", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/contactrequests/1/edit" }.should route_to(:controller => "contactrequests", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/contactrequests" }.should route_to(:controller => "contactrequests", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/contactrequests/1" }.should route_to(:controller => "contactrequests", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/contactrequests/1" }.should route_to(:controller => "contactrequests", :action => "destroy", :id => "1")
    end

  end
end
