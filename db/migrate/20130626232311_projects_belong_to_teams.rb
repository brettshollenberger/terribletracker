class ProjectsBelongToTeams < ActiveRecord::Migration
  def up
    change_column :projects, :team_id, :integer, null: false
  end

  def down
    change_column :projects, :team_id, :integer
  end
end
