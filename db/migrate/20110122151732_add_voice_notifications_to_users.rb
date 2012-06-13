class AddVoiceNotificationsToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :voice_notifications, :boolean, :default => false
  end

  def self.down
    remove_column :users, :voice_notifications
  end
end
