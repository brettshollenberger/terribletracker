class AddPositionToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :position, :integer
  end
end
