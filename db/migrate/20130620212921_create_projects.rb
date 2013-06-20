class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.integer :budget
      t.integer :weekly_rate

      t.timestamps
    end
  end
end
