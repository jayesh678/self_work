class AddFieldsToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :total_amount, :float
    add_column :expenses, :source, :string
    add_column :expenses, :destination, :string
  end
end
