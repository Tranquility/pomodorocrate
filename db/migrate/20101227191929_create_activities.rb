class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table  :activities do |t|
      t.string    :name
      t.text      :description
      t.integer   :estimated_pomodoros
      t.date      :deadline
      t.boolean   :completed

      t.timestamps
    end
    
    add_index :activities, :deadline
    add_index :activities, :completed
  end

  def self.down
    drop_table :activities
  end
end
