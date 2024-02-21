class AddDefaultToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :default, :boolean
  end
end
