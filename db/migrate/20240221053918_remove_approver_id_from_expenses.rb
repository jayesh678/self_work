class RemoveApproverIdFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :approver_id, :integer
  end
end
