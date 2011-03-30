class CreateInterruptions < ActiveRecord::Migration
  def self.up
    create_table :interruptions do |t|
      t.string :type
      t.references :pomodoro

      t.timestamps
    end
  end

  def self.down
    drop_table :interruptions
  end
end
