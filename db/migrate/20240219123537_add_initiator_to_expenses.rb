class AddInitiatorToExpenses < ActiveRecord::Migration[7.1]
  def change
     add_column :expenses, :initiator_id, :integer
  end
end
