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
  belongs_to :user
  #has_one :project, :through => :activity
  
  attr_accessible :activity_id, :comments, :today, :user_id
  
  validates_presence_of :activity_id, :today
  validates_uniqueness_of :activity_id, :scope => :today
  validates :user_id, :presence => true
  validate  :user_must_own_activity
  
  default_scope :order => "today ASC", :conditions => { :today => Date.today }
  
  def user_must_own_activity
    errors.add(:activity, "is not valid") unless ( self.activity.user_id == user_id )
  end
  
end
