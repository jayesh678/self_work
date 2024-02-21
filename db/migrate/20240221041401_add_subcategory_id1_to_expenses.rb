class AddSubcategoryId1ToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :subcategory, foreign_key: true
  end
end
