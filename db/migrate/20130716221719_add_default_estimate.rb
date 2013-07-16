class AddDefaultEstimate < ActiveRecord::Migration
  def up
    change_column :user_stories, :estimate_in_quarter_days, :decimal, default: 0, null: false
  end

  def down
    change_column :user_stories, :estimate_in_quarter_days, :decimal
  end
end
