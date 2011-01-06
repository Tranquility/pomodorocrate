class AddCompletedToPomodoros < ActiveRecord::Migration
  def self.up
    add_column :pomodoros, :completed, :boolean
    add_index :pomodoros, :completed
    add_index :pomodoros, :successful
  end

  def self.down
    remove_column :pomodoros, :completed
    remove_index :pomodoros, :completed
    remove_index :pomodoros, :successful
  end
end
