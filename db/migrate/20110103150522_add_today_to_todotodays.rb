class AddTodayToTodotodays < ActiveRecord::Migration
  def self.up
    add_column :todotodays, :today, :string
    add_index :todotodays, :today
  end

  def self.down
    remove_column :todotodays, :today
    remove_index :todotodays, :today
  end
end
