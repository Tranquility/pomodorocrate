class AddUserIdToBreaks < ActiveRecord::Migration
  def self.up
    add_column :breaks, :user_id, :integer
    add_index :breaks, :user_id
  end

  def self.down
    remove_column :breaks, :user_id
    add_index :breaks, :user_id
  end
end
