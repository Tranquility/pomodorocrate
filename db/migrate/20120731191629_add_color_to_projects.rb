class AddColorToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :color, :string, :limit => 7
  end
end
