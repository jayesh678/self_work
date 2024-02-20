class AddSubcategoriesToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_column :expenses, :subcategories, :string
  end
end
