class AddSourceToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :source, :string
  end
end
