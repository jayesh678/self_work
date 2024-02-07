class AddApplicationNumberToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :application_number, :string
  end
end
