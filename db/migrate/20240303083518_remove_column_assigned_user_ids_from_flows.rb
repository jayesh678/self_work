class RemoveColumnAssignedUserIdsFromFlows < ActiveRecord::Migration[7.1]
  def change
    remove_column :flows, :assigned_user_ids, :text
  end
end
