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
  
  acts_as_list :scope => :user
  
  belongs_to :activity
  belongs_to :user
  #has_one :project, :through => :activity
  
  attr_accessible :activity_id, :comments, :today, :user_id, :position
  
  validates_presence_of :activity_id, :today
  validates_uniqueness_of :activity_id, :scope => :today
  validates :user_id, :presence => true
  validate  :user_must_own_activity
  validates_numericality_of :position, :only_integer => true
  
  default_scope :order => "today ASC, position ASC", :conditions => { :today => Time.now.to_date }
  
  def user_must_own_activity
    errors.add(:activity, "is not valid") unless ( self.activity.user_id == user_id )
  end
  
end
