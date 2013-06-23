class ChangeTeamDescriptionToText < ActiveRecord::Migration
  def up
    change_column :teams, :description, :text, null: false
  end

  def down
    change_column :teams, :description, :string, null: false
  end
end
