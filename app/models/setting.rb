# == Schema Information
# Schema version: 20110116094444
#
# Table name: settings
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  value      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Setting < ActiveRecord::Base
end
