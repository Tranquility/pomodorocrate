class FillTodotodaysUserIds < ActiveRecord::Migration
  def self.up
    td = Todotoday.all
    td.each do |t|
      t.update_attribute(:user_id, t.activity.project.user_id)
    end
  end

  def self.down
    td = Todotoday.all
    td.each do |t|
      t.update_attribute(:user_id, nil)
    end
  end
end
