class CreatePomodoros < ActiveRecord::Migration
  def self.up
    create_table :pomodoros do |t|
      t.references :activity

      t.timestamps
    end
    add_index :pomodoros, :activity_id
  end

  def self.down
    drop_table :pomodoros
  end
end
