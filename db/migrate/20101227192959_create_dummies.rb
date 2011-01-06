class CreateDummies < ActiveRecord::Migration
  def self.up
    create_table :dummies do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :dummies
  end
end
