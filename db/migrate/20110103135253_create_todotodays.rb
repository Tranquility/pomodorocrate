class CreateTodotodays < ActiveRecord::Migration
  def self.up
    create_table :todotodays do |t|
      t.text :comments
      t.references :activity

      t.timestamps
    end
    add_index :todotodays, :activity_id
  end

  def self.down
    drop_table :todotodays
  end
end
