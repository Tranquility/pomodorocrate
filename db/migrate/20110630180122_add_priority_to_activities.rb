class AddPriorityToActivities < ActiveRecord::Migration
  def self.up
    add_column  :activities, :priority, :string, :default => 'none'
    add_index   :activities, :priority
  end

  def self.down
    remove_index    :activities, :priority
    remove_column   :activities, :priority
  end
end
