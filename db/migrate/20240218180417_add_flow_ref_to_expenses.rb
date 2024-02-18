class AddFlowRefToExpenses < ActiveRecord::Migration[7.1]
  def change
    add_reference :expenses, :flow, null: true, foreign_key: true
  end
end
