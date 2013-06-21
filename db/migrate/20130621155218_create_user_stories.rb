class CreateUserStories < ActiveRecord::Migration
  def change
    create_table :user_stories do |t|
      t.string :title, null: false
      t.text :story, null: false
      t.integer :estimate_in_quarter_days
      t.integer :complexity
      t.integer :project_id, null: false

      t.timestamps
    end
  end
end
