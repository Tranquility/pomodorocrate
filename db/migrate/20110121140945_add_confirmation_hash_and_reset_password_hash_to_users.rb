class AddConfirmationHashAndResetPasswordHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :confirmation_hash, :string
    add_column :users, :reset_password_hash, :string
    
    add_index :users, :confirmation_hash
    add_index :users, :reset_password_hash
  end

  def self.down
    remove_column :users, :reset_password_hash
    remove_column :users, :confirmation_hash
    
    remove_index :users, :confirmation_hash
    remove_index :users, :reset_password_hash
  end
end
