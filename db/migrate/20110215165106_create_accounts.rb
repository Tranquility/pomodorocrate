class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name

      t.timestamps
    end
    
    %w(free single team enterprise).each do |a|
      Account.create(:name => a)
    end
    
  end

  def self.down
    drop_table :accounts
  end
end
