class AddExtraInformationToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :information, :string
  end
end
