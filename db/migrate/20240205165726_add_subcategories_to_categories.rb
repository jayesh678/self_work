class AddSubcategoriesToCategories < ActiveRecord::Migration[7.1]
  def change
    add_column :categories, :subcategories, :text
  end
end
