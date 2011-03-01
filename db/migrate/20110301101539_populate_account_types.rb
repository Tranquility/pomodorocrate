class PopulateAccountTypes < ActiveRecord::Migration
  def self.up
    accounts = %w{free single team enterprise beta}
    accounts.each do |a|
      account = Account.new
      account.name = a
      account.save
    end
  end

  def self.down
    accounts = %w{free single team enterprise beta}
    accounts.each do |a|
      account = Account.find_by_name(a)
      account.destroy unless account.nil?
    end
  end
end
