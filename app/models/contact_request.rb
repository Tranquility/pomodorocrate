# used in the app, for feedback requests
class ContactRequest < ActiveRecord::Base
  belongs_to :user

  attr_accessible :content, :bug, :feature_request, :suggestion, :debug_info

  validates :content, :presence => true
end
