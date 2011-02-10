class AddPomodoroLengthAndShortBreakLengthAndLongBreakLengthToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :pomodoro_length, :integer, :default => 25
    add_column :users, :short_break_length, :integer, :default => 5
    add_column :users, :long_break_length, :integer, :default => 25
  end

  def self.down
    remove_column :users, :long_break_length
    remove_column :users, :short_break_length
    remove_column :users, :pomodoro_length
  end
end
