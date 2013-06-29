class NoDescriptionRequiredTeam < ActiveRecord::Migration
  def up
    change_column :teams, :description, :text, null: true
  end

  def down
    change_column :teams, :description, :text, null: false
  end
end
