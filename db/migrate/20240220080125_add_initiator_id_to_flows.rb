class AddInitiatorIdToFlows < ActiveRecord::Migration[7.1]
  def change
    add_column :flows, :initiator_id, :integer
  end
end
