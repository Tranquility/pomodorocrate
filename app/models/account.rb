class Account < ActiveRecord::Base
  
  attr_accessible
  
  has_many :users
  
end
