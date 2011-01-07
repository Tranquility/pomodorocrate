class Pomodoro < ActiveRecord::Base
  belongs_to :activity
  
  attr_accessible :activity_id, :successful, :comments, :completed
  
  validates :activity_id, :presence => true
  
  scope :successful_and_completed, :conditions => { :successful => true, :completed => true }
  
  def self.length
    25
  end
end
