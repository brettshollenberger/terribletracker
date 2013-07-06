class AddStateToTeams < ActiveRecord::Migration
  def change
    add_column :teams, :state, :string, null: false, default: "active"
  end
end
