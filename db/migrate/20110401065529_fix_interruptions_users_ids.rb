class FixInterruptionsUsersIds < ActiveRecord::Migration
  def self.up
    Interruption.all.each do |i|
      i.user_id = i.pomodoro.user_id
      i.save
    end
  end

  def self.down
  end
end
