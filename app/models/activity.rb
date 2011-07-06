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
  
  acts_as_taggable
  has_event_calendar
  
  has_one     :todotoday, :dependent => :destroy
  has_many    :pomodoros, :dependent => :destroy
  has_many    :comments,  :dependent => :destroy
  belongs_to  :project
  belongs_to  :user
  
  attr_accessible :name, :description, :estimated_pomodoros, :deadline, :completed, :project_id, :start_at, :end_at, :event_type, :unplanned, :tag_list, :priority
  attr_accessor :color
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
  validates :estimated_pomodoros, :numericality => true,
                                  :inclusion => { :in => 0..8 }
  validates :project, :presence => true
  validates :user,    :presence => true
  validate  :deadline_can_not_be_in_the_past, :on => :create
  validate  :user_must_own_project
  validate  :start_at_must_be_smaller_than_end_at, :if => :event_type?
  validates :priority, :inclusion => { :in => Ketchup::Application.config.activity_priority_list.values  }
  
  default_scope :order => "activities.completed ASC, activities.deadline ASC, #{ActiveRecord::Base.connection.adapter_name.downcase.to_sym == :mysql ? "FIELD( priority, 'high', 'medium_high', 'medium', 'medium_low', 'low', 'none')" : "CASE WHEN priority = 'high' THEN 1 WHEN priority = 'medium_high' THEN 2 WHEN priority = 'medium' THEN 3 WHEN priority = 'medium_low' THEN 4 WHEN priority = 'low' THEN 5 WHEN priority = 'none' THEN 6 END"}"
  scope :not_completed, lambda { |current_user| { :conditions => { :completed => false, :user_id => current_user.id } } }
  
  before_save   :prepare_calendar_dates
  before_create :prepare_calendar_dates
  
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
      self.start_at = DateTime.parse( "#{self.deadline.year}-#{self.deadline.month}-#{self.deadline.day} #{self.start_at.hour}:#{self.start_at.min}") 
      self.start_at -= (self.start_at.utc_offset / 3600).hours
      
      self.end_at = self.end_at.nil? ? DateTime.parse( Date.today.to_s ) : self.end_at.to_datetime
      self.end_at = DateTime.parse( "#{self.deadline.year}-#{self.deadline.month}-#{self.deadline.day} #{self.end_at.hour}:#{self.end_at.min}")
      self.end_at -= (self.end_at.utc_offset / 3600).hours
    end
  
end
