class SetDefaultValuesWhereUserIdIsMissing < ActiveRecord::Migration
  def self.up
    
    as = Activity.where(:user_id => nil)
    as.each do |a|
      as.update_attribute(:user_id => 1)
    end
    
    tds = Todotoday.where(:user_id => "")
    tds.each do |td|
      td.update_attribute(:user_id => 1)
    end
    
    pms = Pomodoro.where(:user_id => nil)
    pms.each do |p|
      p.update_attribute(:user_id => 1)
    end
    
  end

  def self.down
  end
end
