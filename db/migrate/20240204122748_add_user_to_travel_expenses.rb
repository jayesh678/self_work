class AddUserToTravelExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :travel_expenses, :user, null: false, foreign_key: true
  end
end
