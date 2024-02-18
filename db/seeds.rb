# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# db/seeds.rb

Category.create(name: 'Expense', category_type: 'Regular')
Category.create(name: 'Travel Expense', category_type: 'Travel')

Role.create(role_name: "super_admin")
Role.create(role_name: "admin")
Role.create(role_name: "user")

Company.create(company_name: "THinkbiz", company_code: "TBZ1289")

regular_category = Category.find_by(name: 'Expense')
regular_category.subcategories.create(name: 'Lunch')
regular_category.subcategories.create(name: 'Breakfast')
regular_category.subcategories.create(name: 'Dinner')

travel_category = Category.find_by(name: 'Travel Expense')
travel_category.subcategories.create(name: 'Train')
travel_category.subcategories.create(name: 'Car')
travel_category.subcategories.create(name: 'Bus')

