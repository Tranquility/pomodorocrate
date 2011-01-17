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
  
  pomodoro_joins = "JOIN activities ON activities.id = pomodoros.activity_id JOIN projects ON projects.id = activities.project_id"
  default_scope :select => "pomodoros.*", :joins => pomodoro_joins
  scope :successful_and_completed, :select => "pomodoros.*", :conditions => { :successful => true, :completed => true }, :joins => pomodoro_joins
  
  def self.length
    25
  end
end
