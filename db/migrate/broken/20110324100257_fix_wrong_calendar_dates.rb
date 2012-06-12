class FixWrongCalendarDates < ActiveRecord::Migration
  def self.up
    Activity.all.each do |a|
      sa = DateTime.parse(a.start_at.to_s)
      ea = DateTime.parse(a.end_at.to_s)
      a.update_attribute(:start_at, DateTime.parse( "#{a.deadline.year}-#{a.deadline.month}-#{a.deadline.day} #{sa.hour}:#{sa.minute}"))
      a.update_attribute(:end_at, DateTime.parse( "#{a.deadline.year}-#{a.deadline.month}-#{a.deadline.day} #{ea.hour}:#{ea.minute}"))
    end
  end

  def self.down
  end
end
