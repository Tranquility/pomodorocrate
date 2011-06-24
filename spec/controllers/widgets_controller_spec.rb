require 'spec_helper'

describe WidgetsController do

  describe "GET 'active_pomodoro'" do
    it "should be successful" do
      get 'active_pomodoro'
      response.should be_success
    end
  end

end
