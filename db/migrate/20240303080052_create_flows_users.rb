class CreateFlowsUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :flows_users, id: false do |t|
      t.belongs_to :flow
      t.belongs_to :user
    end
  end
end
