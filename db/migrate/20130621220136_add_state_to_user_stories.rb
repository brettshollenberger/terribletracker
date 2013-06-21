class AddStateToUserStories < ActiveRecord::Migration
  def change
    add_column :user_stories, :state, :string, null: false, default: "unstarted"
  end
end
