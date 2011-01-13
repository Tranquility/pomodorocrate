class Project < ActiveRecord::Base
  
  has_many :activities, :dependent => :destroy
  
  attr_accessible :name, :description
  
  validates :name,  :presence => true,
                    :length => { :maximum => 100 }, 
                    :uniqueness => true
                    
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
    self.completed_pomodoros * 100 / self.total_pomodoros
  end
  
  def deadline
    return self.activities.maximum(:deadline)
  end
  
  def started_at
    return self.activities.minimum(:deadline)
  end
  
  def activity_in_progress

  end
  
end
