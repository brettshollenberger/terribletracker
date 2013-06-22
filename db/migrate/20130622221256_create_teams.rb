class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name, null: false
      t.string :description
      t.integer :owner_id, null: false
      t.string :website

      t.timestamps
    end
  end
end
