class RemoveSubcategoreisFromExpenses < ActiveRecord::Migration[7.1]
  def change
    remove_column :expenses, :subcategories, :string
  end
end
