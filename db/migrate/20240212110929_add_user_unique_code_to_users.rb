class AddUserUniqueCodeToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :user_code, :string
  end
end
