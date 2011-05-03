class AddCachedTagListToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :cached_tag_list, :string
  end

  def self.down
    remove_column :activities, :cached_tag_list
  end
end
