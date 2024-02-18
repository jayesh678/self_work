class AddDefaultToFlows < ActiveRecord::Migration[7.1]
  def change
    add_column :flows, :default, :boolean
  end
end
