class AddSuccessfulAndCommentsToPomodoros < ActiveRecord::Migration
  def self.up
    add_column :pomodoros, :successful, :boolean
    add_column :pomodoros, :comments, :text
  end

  def self.down
    remove_column :pomodoros, :comments
    remove_column :pomodoros, :successful
  end
end
