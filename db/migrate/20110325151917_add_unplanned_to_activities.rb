class AddUnplannedToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :unplanned, :boolean, :default => false
    add_index :activities, :unplanned
  end

  def self.down
    remove_index :activities, :unplanned
    remove_column :activities, :unplanned
  end
end
