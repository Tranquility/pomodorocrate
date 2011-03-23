class SetDefaultValuesForActivitiesStartAtAndEndAt < ActiveRecord::Migration
  
  def self.up
    Activity.all.each do |activity|
      activity.update_attribute(:start_at, activity.deadline.to_datetime) unless activity.deadline.nil? and !activity.start_at.nil?
      activity.update_attribute(:end_at, activity.deadline.to_datetime) unless activity.deadline.nil? and !activity.start_at.nil?
    end
  end

  def self.down
    Activity.all.each do |activity|
      activity.update_attribute(:start_at, nil)
      activity.update_attribute(:end_at, nil) 
    end
  end
end
