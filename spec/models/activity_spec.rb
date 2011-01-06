require 'spec_helper'

describe Activity do
  
  before(:each) do
    @attr = {
      :name                 => "Some important activity",
      :description          => "This is a very important activity, really",
      :estimated_pomodoros  => 6,
      :deadline             => 2.days.from_now,
      :completed            => false
    }
  end
  
  it "should create a new instance given valid attributes" do
    Activity.create!(@attr)
  end
  
  describe "name validations" do
    
    it "should require a name" do
      Activity.new( @attr.merge(:name => "") ).should_not be_valid
    end
    
    it "should reject names that are too long" do
      long_name = "a" * 101
      Activity.new( @attr.merge(:name => long_name) ).should_not be_valid
    end
    
  end
  
  describe "estimated_pomodoros" do
    
    it "should be an integer" do
      Activity.new( @attr.merge(:estimated_pomodoros => "foobar") ).should_not be_valid
    end
    
    it "should be bigger than 0" do
      Activity.new( @attr.merge(:estimated_pomodoros => -1) ).should_not be_valid
      Activity.new( @attr.merge(:estimated_pomodoros => 0) ).should_not be_valid
    end
    
    it "should be smaller than 8" do
      Activity.new( @attr.merge(:estimated_pomodoros => 9) ).should_not be_valid
    end
    
  end
  
  describe "deadline" do
    
    it "should not be in the past" do
      Activity.new( @attr.merge(:deadline => Date.today.prev_day) ).should_not be_valid
    end
    
  end
  
end
