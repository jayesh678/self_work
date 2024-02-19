class AddApproverIdToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :approver_id, :integer
  end
end
