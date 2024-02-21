class RemoveInitiatorIdAndDefaultFromFlows < ActiveRecord::Migration[7.1]
  def change
    remove_column :flows, :initiator_id, :integer
    remove_column :flows, :default, :boolean
  end
end
