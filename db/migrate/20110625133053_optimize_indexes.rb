class OptimizeIndexes < ActiveRecord::Migration
  def self.up
    add_index :pomodoros, :created_at
    add_index :todotodays, :position
    add_index :projects, :completed
    add_index :projects, :name
  end

  def self.down
    remove_index :pomodoros, :created_at
    remove_index :todotodays, :position
    remove_index :projects, :completed
    remove_index :projects, :name
  end
end
