class CreateBreaks < ActiveRecord::Migration
  def self.up
    create_table :breaks do |t|
      t.boolean :completed
      t.integer :duration, :default => 5

      t.timestamps
    end
    add_index :breaks, :completed
  end

  def self.down
    drop_table    :breaks
    remove_index  :breaks, :completed
  end
end
