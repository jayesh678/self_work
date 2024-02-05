class CreateTravelExpenses < ActiveRecord::Migration[7.1]
  def change
    create_table :travel_expenses do |t|
      t.float :amount
      t.float :tax_amount
      t.integer :application_number
      t.string :description
      t.date :date
      t.integer :number_of_people
      t.date :expense_date
      t.string :receipt
      t.integer :status
      t.string :source
      t.string :destination

      t.timestamps
    end
  end
end
