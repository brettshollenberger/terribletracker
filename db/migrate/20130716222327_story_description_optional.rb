class StoryDescriptionOptional < ActiveRecord::Migration
  def up
    change_column :user_stories, :story, :text, null: true
  end

  def down
    change_column :user_stories, :story, :text, null: false
  end
end
