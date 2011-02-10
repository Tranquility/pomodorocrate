class AddPositionToTodotodays < ActiveRecord::Migration
  def self.up
    add_column :todotodays, :position, :integer

    todotodays = Todotoday.all
    todotodays.each_with_index do |td, index|
      td.position = index +1
      td.save! 
    end
  end

  def self.down
    remove_column :todotodays, :position
  end
end
