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
  
  has_event_calendar
  
  has_one     :todotoday, :dependent => :destroy
  has_many    :pomodoros, :dependent => :destroy
  belongs_to  :project
  belongs_to  :user
  
  attr_accessible :name, :description, :estimated_pomodoros, :deadline, :completed, :project_id, :start_at, :end_at, :event_type, :unplanned
  attr_accessor :color
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
  validates :estimated_pomodoros, :numericality => true,
                                  :inclusion => { :in => 0..8 }
  validates :project, :presence => true
  validates :user,    :presence => true
  validate  :deadline_can_not_be_in_the_past
  validate  :user_must_own_project
  validate  :start_at_must_be_smaller_than_end_at, :if => :event_type?
  
  default_scope :order => "activities.completed ASC, activities.deadline ASC"
  
  before_save :prepare_calendar_dates
  
  cattr_reader :per_page
  @@per_page = 40
  
  def deadline_can_not_be_in_the_past
    errors.add(:deadline, "can't be in the past") unless ( deadline == Date.today or deadline.future? )
  end
  
  def user_must_own_project
    errors.add(:project, "is not valid") unless ( self.project.user_id == user_id )
  end
  
  def start_at_must_be_smaller_than_end_at
    errors.add(:end_at, "must be after Start at") if ( start_at >= end_at )
  end
  
  private
  
    def prepare_calendar_dates
      self.start_at = self.start_at.nil? ? DateTime.parse( Date.today.to_s ) : self.start_at.to_datetime
      self.start_at = DateTime.parse( "#{self.deadline.year}-#{self.deadline.month}-#{self.deadline.day} #{self.start_at.hour}:#{self.start_at.minute}") 
      self.start_at -= (self.start_at.utc_offset / 3600).hours
      
      self.end_at = self.end_at.nil? ? DateTime.parse( Date.today.to_s ) : self.end_at.to_datetime
      self.end_at = DateTime.parse( "#{self.deadline.year}-#{self.deadline.month}-#{self.deadline.day} #{self.end_at.hour}:#{self.end_at.minute}")
      self.end_at -= (self.end_at.utc_offset / 3600).hours
    end
  
end
