class ModifySettingsTable < ActiveRecord::Migration
  def self.up
    begin
      drop_table :settings
    rescue
    end
    
    create_table  :settings do |t|
      t.boolean   :tooltips,                    :default => false
      
      t.boolean   :ring_sound,                  :default => true
      t.boolean   :tick_tack_sound,             :default => true
      t.boolean   :voice_notifications,         :default => true
      
      t.integer   :ring_sound_volume,           :default => 10
      t.integer   :tick_tack_sound_volume,      :default => 5
      t.integer   :voice_notifications_volume,  :default => 10
      
      t.boolean   :email_notifications,         :default => true
      
      t.integer   :pomodoro_length,             :default => 25
      t.integer   :short_break_length,          :default => 5
      t.integer   :long_break_length,           :default => 30
      
      t.references :user
      t.timestamps
    end
    
    add_index :settings, :user_id
  end

  def self.down
    drop_table :settings
  end
end
