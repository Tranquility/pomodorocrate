class PopulateActivitiesUserId < ActiveRecord::Migration
  def self.up
    activities = Activity.all
    activities.each do |a|
      a.user_id = a.project.user_id
      a.save
    end
  end

  def self.down
    activities = Activity.all
    activities.each do |a|
      a.user_id = nil
      a.save
    end
  end
end
