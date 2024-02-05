class AddBusinessPartnerIdToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :business_partner, null: false, foreign_key: true
  end
end
