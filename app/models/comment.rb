class Comment < ActiveRecord::Base
  belongs_to :activity
  belongs_to :user
  
  attr_accessible :content, :activity_id, :user_id
  
  validates :content,   :presence => true
  validates :activity,  :presence => true
  validates :user,      :presence => true
end
