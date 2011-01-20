class AddUserIdToPomodoros < ActiveRecord::Migration
  def self.up
    add_column :pomodoros, :user_id, :integer
    add_index :pomodoros, :user_id
  end

  def self.down
    remove_column :pomodoros, :user_id
    remove_index :pomodoros, :user_id
  end
end
