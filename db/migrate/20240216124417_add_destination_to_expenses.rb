class AddDestinationToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :destination, :string
  end
end
