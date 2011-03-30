class AddUserIdToInterruptions < ActiveRecord::Migration
  def self.up
    add_column :interruptions, :user_id, :integer
    add_index :interruptions, :user_id
  end

  def self.down
    remove_index :interruptions, :user_id
    remove_column :interruptions, :user_id
  end
end
