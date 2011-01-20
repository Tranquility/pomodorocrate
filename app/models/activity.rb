# == Schema Information
# Schema version: 20110116094444
#
# Table name: activities
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  description         :text
#  estimated_pomodoros :integer
#  deadline            :date
#  completed           :boolean
#  created_at          :datetime
#  updated_at          :datetime
#  project_id          :integer
#

class Activity < ActiveRecord::Base
  
  has_one     :todotoday, :dependent => :destroy
  has_many    :pomodoros, :dependent => :destroy
  belongs_to  :project
  belongs_to  :user
  
  attr_accessible :name, :description, :estimated_pomodoros, :deadline, :completed, :project_id
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
  validates :estimated_pomodoros, :numericality => true,
                                  :inclusion => { :in => 0..8 }
  validates :project, :presence => true
  validates :user,    :presence => true
  validate  :deadline_can_not_be_in_the_past
  validate  :user_must_own_project
  
  default_scope :order => "activities.completed ASC, activities.deadline ASC"
  
  cattr_reader :per_page
  @@per_page = 60
  
  def deadline_can_not_be_in_the_past
    errors.add(:deadline, "can't be in the past") unless ( deadline == Date.today or deadline.future? )
  end
  
  def user_must_own_project
    errors.add(:project, "is not valid") unless ( self.project.user_id == user_id )
  end
  
end
