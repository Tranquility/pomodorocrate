# == Schema Information
# Schema version: 20110116094444
#
# Table name: breaks
#
#  id         :integer         not null, primary key
#  completed  :boolean
#  duration   :integer         default(5)
#  created_at :datetime
#  updated_at :datetime
#

class Break < ActiveRecord::Base
  
  def self.duration
    5
  end
  
  def self.long_duration
    25
  end
  
end
