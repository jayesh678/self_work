class CreateFlows < ActiveRecord::Migration[7.1]
  def change
    create_table :flows do |t|
      t.integer :user_assigned_id
      t.integer :assigned_user_id
      t.integer :flow_levels
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
  end
end
