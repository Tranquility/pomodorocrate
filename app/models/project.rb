# == Schema Information
# Schema version: 20110116094444
#
# Table name: projects
#
#  id          :integer         not null, primary key
#  name        :string(255)
#  description :text
#  created_at  :datetime
#  updated_at  :datetime
#

class Project < ActiveRecord::Base
  
  has_many :activities, :dependent => :destroy
  has_many :todotodays, :through =>:activities
  belongs_to :user
  
  attr_accessible :name, :description
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }
                    # :uniqueness => true
                    
  default_scope :order => "projects.name ASC"
     
  def total_pomodoros
    total_pomodoros = 0
    self.activities.each do |a|
      total_pomodoros += a.estimated_pomodoros
    end
    
    total_pomodoros
  end
  
  def completed_pomodoros
    completed_pomodoros = 0
    self.activities.each do |a|
      completed_pomodoros += a.pomodoros.successful_and_completed.count
    end
    
    completed_pomodoros
  end
                    
  def completness
    return 0 if self.total_pomodoros == 0
    if (c = self.completed_pomodoros * 100 / self.total_pomodoros) < 100
      return c
    else
      return 100
    end
  end
  
  def deadline
    deadline =  self.activities.maximum(:deadline)
    deadline.nil? ? nil : deadline.to_date.to_s(:rfc822)
  end
  
  def started_at
    started_at = self.activities.minimum(:deadline)
    started_at.nil? ? nil : started_at.to_date.to_s(:rfc822) 
  end
  
  def activity_in_progress

  end
  
end
