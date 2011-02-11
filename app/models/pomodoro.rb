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
  belongs_to :user
  
  attr_accessible :activity_id, :successful, :comments, :completed, :user_id, :duration
  
  validates :activity_id, :presence => true
  validates :user_id, :presence => true
  validates :duration, :presence => true
  validates_numericality_of :duration,  :only_integer => true,
                                        :greater_than_or_equal_to => 5,
                                        :less_than_or_equal_to => 60
  
  scope :successful_and_completed, :conditions => { :successful => true, :completed => true }
  
  def self.length
    25
  end
end
