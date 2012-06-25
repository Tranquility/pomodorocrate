class CreateAccounts < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.string :name

      t.timestamps
    end
    
    %w(free single team enterprise).each do |a|
      # XXX this is actually seed data
      account = Account.new
      account.name = a
      account.save!
    end
    
  end

  def self.down
    drop_table :accounts
  end
end
