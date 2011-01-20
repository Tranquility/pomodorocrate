class AddUserIdToTodotodays < ActiveRecord::Migration
  def self.up
    add_column  :todotodays, :user_id, :integer
    add_index   :todotodays, :user_id
  end

  def self.down
    remove_column :todotodays, :user_id
    remove_index  :todotodays, :user_id
  end
end
