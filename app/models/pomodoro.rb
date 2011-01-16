# == Schema Information
# Schema version: 20110116094444
#
# Table name: pomodoros
#
#  id          :integer         not null, primary key
#  activity_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  successful  :boolean
#  comments    :text
#  completed   :boolean
#

class Pomodoro < ActiveRecord::Base
  
  belongs_to :activity
  
  attr_accessible :activity_id, :successful, :comments, :completed
  
  validates :activity_id, :presence => true
  
  scope :successful_and_completed, :conditions => { :successful => true, :completed => true }
  
  def self.length
    25
  end
end
