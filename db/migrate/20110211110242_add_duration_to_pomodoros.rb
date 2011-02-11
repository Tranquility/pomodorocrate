class AddDurationToPomodoros < ActiveRecord::Migration
  def self.up
    add_column :pomodoros, :duration, :integer, :default => 25
  end

  def self.down
    remove_column :pomodoros, :duration
  end
end
