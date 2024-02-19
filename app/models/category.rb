class Category < ApplicationRecord
  has_many :expenses, class_name: 'Expense', foreign_key: 'category_id'
  has_many :travel_expenses, class_name: 'TravelExpense', foreign_key: 'category_id'
    has_many :subcategories

  validates :name, presence: true
end
