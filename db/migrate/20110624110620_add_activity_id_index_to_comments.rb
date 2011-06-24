class AddActivityIdIndexToComments < ActiveRecord::Migration
  def self.up
    add_index :comments, :activity_id
    add_index :comments, :user_id
  end

  def self.down
    remove_index :comments, :activity_id
    remove_index :comments, :user_id
  end
end
