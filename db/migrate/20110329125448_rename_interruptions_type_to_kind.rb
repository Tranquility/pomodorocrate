class RenameInterruptionsTypeToKind < ActiveRecord::Migration
  def self.up
    rename_column :interruptions, :type, :kind
  end

  def self.down
    rename_column :interruptions, :kind, :type
  end
end
