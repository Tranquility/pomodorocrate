class AddProjectToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :project_id, :integer
    add_index :activities, :project_id
  end

  def self.down
    remove_column :activities, :project
    remove_index :activities, :project_id
  end
end
