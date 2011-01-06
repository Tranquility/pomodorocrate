class Pomodoro < ActiveRecord::Base
  belongs_to :activity
  
  attr_accessible :activity_id, :successful, :comments, :completed
  
  validates :activity_id, :presence => true
end
