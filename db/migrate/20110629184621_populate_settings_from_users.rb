class PopulateSettingsFromUsers < ActiveRecord::Migration
  def self.up
    users = User.all
    users.each do |u|
      u.setting = Setting.new
      
      u.setting.tick_tack_sound = u.tick_tack_sound
      u.setting.voice_notifications = u.voice_notifications
      u.setting.email_notifications = u.email_notifications
      u.setting.pomodoro_length = u.pomodoro_length
      u.setting.short_break_length = u.short_break_length
      u.setting.long_break_length = u.long_break_length
      
      u.setting.save
    end
  end

  def self.down
  end
end
