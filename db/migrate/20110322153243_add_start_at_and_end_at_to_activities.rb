class AddStartAtAndEndAtToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :start_at, :datetime
    add_column :activities, :end_at, :datetime
    add_column :activities, :event_type, :boolean, :default => false
    
    add_index :activities, :start_at
    add_index :activities, :end_at
    add_index :activities, :event_type
  end

  def self.down
    remove_index :activities, :start_at
    remove_index :activities, :end_at
    remove_index :activities, :event_type
    
    remove_column :activities, :start_at
    remove_column :activities, :end_at
    remove_column :activities, :event_type
  end
end