class ChangeAssignedUserIdsToStringInFlows < ActiveRecord::Migration[7.1]
  def change
    change_column :flows, :assigned_user_ids, :string
  end
end
