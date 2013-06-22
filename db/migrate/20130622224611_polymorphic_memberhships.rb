class PolymorphicMemberhships < ActiveRecord::Migration
  def up
    remove_column :memberships, :project_id
    add_column :memberships, :joinable_id, :integer, null: false
    add_column :memberships, :joinable_type, :string, null: false
  end

  def down
    remove_column :memberships, :joinable_id
    remove_column :memberships, :joinable_type
    add_column :memberships, :project_id, :integer, null: false
  end
end
