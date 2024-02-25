class AddTotalAmountAndApplicationNameToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :total_amount, :float
    add_column :expenses, :application_name, :string
  end
end
