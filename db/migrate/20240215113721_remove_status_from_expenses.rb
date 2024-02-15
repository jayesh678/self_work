class RemoveStatusFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :Expenses, :Status, :integer
  end
end
