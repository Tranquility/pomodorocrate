class Interruption < ActiveRecord::Base
  
  belongs_to :user
  belongs_to :pomodoro
  
  attr_accessible :kind, :pomodoro_id, :user_id
  
  validates :pomodoro_id, :presence => true
  validates :kind,        :presence => true
  validates_inclusion_of :kind, :in => %w( internal external ), :message => " %{value} is not a valid Pomodoro Technique interruption"
  
end
