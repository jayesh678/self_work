class AddStatusTonExpenses < ActiveRecord::Migration[7.1]
    def change
        add_column :Expenses, :status, :integer, default: 0
    end
end
