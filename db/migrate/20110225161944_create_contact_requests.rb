class CreateContactRequests < ActiveRecord::Migration
  def self.up
    create_table :contact_requests do |t|
      t.text :content
      t.boolean :bug
      t.boolean :feature_request
      t.boolean :suggestion
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :contact_requests
  end
end
