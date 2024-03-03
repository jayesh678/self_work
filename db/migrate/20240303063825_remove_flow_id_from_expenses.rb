class RemoveFlowIdFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :flow_id, :integer
  end
end
