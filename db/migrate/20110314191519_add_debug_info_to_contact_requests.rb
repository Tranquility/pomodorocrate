class AddDebugInfoToContactRequests < ActiveRecord::Migration
  def self.up
    add_column :contact_requests, :debug_info, :text
  end

  def self.down
    remove_column :contact_requests, :debug_info
  end
end
