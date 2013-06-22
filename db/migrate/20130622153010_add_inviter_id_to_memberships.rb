class AddInviterIdToMemberships < ActiveRecord::Migration
  def change
    add_column :memberships, :inviter_id, :integer
  end
end
