# used in the app, for feedback requests
class ContactRequest < ActiveRecord::Base
  belongs_to :user
end
