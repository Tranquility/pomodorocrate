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
  
  include SessionsHelper
  
  belongs_to :activity
  belongs_to :user
  has_many  :interruptions, :dependent => :destroy
  
  attr_accessible :activity_id, :successful, :comments, :completed, :user_id, :duration
  
  validates :activity_id, :presence => true
  validates :user_id, :presence => true
  validates :duration, :presence => true
  validates_numericality_of :duration,  :only_integer => true,
                                        :greater_than_or_equal_to => 5,
                                        :less_than_or_equal_to => 60
  #validate :cant_exceed_ten_completed_pomodoros_per_activity
  
  scope :successful_and_completed, :conditions => { :successful => true, :completed => true }
  scope :today, lambda { |current_user| { :conditions => { :created_at => Date.today.beginning_of_day..Date.today.end_of_day, :user_id => current_user.id } } }
  
  def cant_exceed_ten_completed_pomodoros_per_activity
    errors.add(:pomodoro, "count per activity was exceeded") if self.activity.pomodoros.successful_and_completed.count >= 10
  end
end
