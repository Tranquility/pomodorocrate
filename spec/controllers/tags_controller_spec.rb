require 'spec_helper'

describe TagsController do

  describe "GET 'user_tags'" do
    it "should be successful" do
      get 'user_tags'
      response.should be_success
    end
  end

  describe "GET 'activity_tags'" do
    it "should be successful" do
      get 'activity_tags'
      response.should be_success
    end
  end

  describe "GET 'project_tags'" do
    it "should be successful" do
      get 'project_tags'
      response.should be_success
    end
  end

end
