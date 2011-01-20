class GeneratePomodorosUserIds < ActiveRecord::Migration
  def self.up
    pomodoros = Pomodoro.all
    pomodoros.each do |p|
      p.update_attribute(:user_id, p.activity.project.user_id)
    end
  end

  def self.down
    pomodoros = Pomodoro.all
    pomodoros.each do |p|
      p.update_attribute(:user_id, nil)
    end
  end
end
