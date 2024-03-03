class AddExpenseIdToFlows < ActiveRecord::Migration[7.1]
  def change
    add_column :flows, :expense_id, :integer
  end
end
