class RenameAssignedUserIdInFlows < ActiveRecord::Migration[7.1]
  def change
    rename_column :flows, :assigned_user_id, :assigned_user_ids
  end
end
