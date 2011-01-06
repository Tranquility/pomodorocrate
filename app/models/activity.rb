class Activity < ActiveRecord::Base
  
  has_one :todotoday
  has_many :pomodoros
  
  attr_accessible :name, :description, :estimated_pomodoros, :deadline, :completed
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
  validates :estimated_pomodoros, :numericality => true,
                                  :inclusion => { :in => 0..8 }
  validate :deadline_can_not_be_in_the_past
  
  default_scope :order => "activities.deadline ASC"
  
  def deadline_can_not_be_in_the_past
    errors.add(:deadline, "can't be in the past") unless ( deadline == Date.today or deadline.future? )
  end
  
end
