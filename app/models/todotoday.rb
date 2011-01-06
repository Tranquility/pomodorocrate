class Todotoday < ActiveRecord::Base
  
  belongs_to :activity
  
  attr_accessible :activity_id, :comments, :today
  
  validates_presence_of :activity_id, :today
  validates_uniqueness_of :activity_id, :scope => :today
  
  default_scope :order => "todotodays.today ASC", :conditions => { :today => Date.today }
  
end
