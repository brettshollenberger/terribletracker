class ProjectDescriptionCanBeBlank < ActiveRecord::Migration
  def up
    change_column :projects, :description, :text, null: true
  end

  def down
    change_column :projects, :description, :text, null: false
  end
end
