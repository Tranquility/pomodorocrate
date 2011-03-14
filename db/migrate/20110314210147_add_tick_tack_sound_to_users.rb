class AddTickTackSoundToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :tick_tack_sound, :boolean, :default => false
  end

  def self.down
    remove_column :users, :tick_tack_sound
  end
end
