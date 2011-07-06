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
  belongs_to :user
  
  validates_numericality_of :pomodoro_length, :only_integer => true,
                                              :greater_than_or_equal_to => 5,
                                              :less_than_or_equal_to => 60
  
  validates_numericality_of :short_break_length,  :only_integer => true,
                                                  :greater_than_or_equal_to => 5,
                                                  :less_than_or_equal_to => 60
                                  
  validates_numericality_of :long_break_length, :only_integer => true,
                                                :greater_than_or_equal_to => 5,
                                                :less_than_or_equal_to => 60
                                                
  validates_numericality_of :ring_sound_volume, :only_integer => true,
                                                :greater_than_or_equal_to => 0,
                                                :less_than_or_equal_to => 10
                                                
  validates_numericality_of :tick_tack_sound_volume,  :only_integer => true,
                                                      :greater_than_or_equal_to => 0,
                                                      :less_than_or_equal_to => 10
                                                      
  validates_numericality_of :voice_notifications_volume,  :only_integer => true,
                                                          :greater_than_or_equal_to => 0,
                                                          :less_than_or_equal_to => 10
end
