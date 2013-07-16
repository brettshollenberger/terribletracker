class ChangeEstimateInQuarterDaysToDecimal < ActiveRecord::Migration
  def up
    change_column :user_stories, :estimate_in_quarter_days, :decimal
  end

  def down
    change_column :user_stories, :estimate_in_quarter_days, :integer
  end
end
