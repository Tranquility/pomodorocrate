class AddSomedayToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :someday, :boolean
    add_index :activities, :someday
  end
end
