require "spec_helper"

describe BreaksController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/breaks" }.should route_to(:controller => "breaks", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/breaks/new" }.should route_to(:controller => "breaks", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/breaks/1" }.should route_to(:controller => "breaks", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/breaks/1/edit" }.should route_to(:controller => "breaks", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/breaks" }.should route_to(:controller => "breaks", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/breaks/1" }.should route_to(:controller => "breaks", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/breaks/1" }.should route_to(:controller => "breaks", :action => "destroy", :id => "1")
    end

  end
end
