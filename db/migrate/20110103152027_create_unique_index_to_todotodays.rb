class CreateUniqueIndexToTodotodays < ActiveRecord::Migration
  def self.up
    add_index :todotodays, [:activity_id, :today], :unique => true
  end

  def self.down
    remove_index :todotodays, [:activity_id, :today]
  end
end
