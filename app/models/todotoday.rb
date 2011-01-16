# == Schema Information
# Schema version: 20110116094444
#
# Table name: todotodays
#
#  id          :integer         not null, primary key
#  comments    :text
#  activity_id :integer
#  created_at  :datetime
#  updated_at  :datetime
#  today       :string(255)
#

class Todotoday < ActiveRecord::Base
  
  belongs_to :activity
  
  attr_accessible :activity_id, :comments, :today
  
  validates_presence_of :activity_id, :today
  validates_uniqueness_of :activity_id, :scope => :today
  
  default_scope :order => "todotodays.today ASC", :conditions => { :today => Date.today }
  
end
