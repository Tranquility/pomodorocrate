class ActsAsTaggableOnMigration < ActiveRecord::Migration
  def self.up
    # You should make sure that the column created is
    # long enough to store the required class names.
    add_column :taggings, :tagger_id, :integer
    add_column :taggings, :tagger_type, :integer
    # limit is created to prevent mysql error o index lenght for myisam table type.
    # http://bit.ly/vgW2Ql
    add_column :taggings, :context, :string, :limit => 128

    remove_index :taggings, [:taggable_id, :taggable_type]
    add_index :taggings, [:taggable_id, :taggable_type, :context]
  end

  def self.down
    remove_index :taggings, [:taggable_id, :taggable_type, :context]
    add_index :taggings, [:taggable_id, :taggable_type]
    remove_columns :taggings, :context, :tagger_type, :tagger_id
  end
end
