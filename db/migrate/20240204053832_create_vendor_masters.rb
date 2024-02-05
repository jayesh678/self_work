class CreateVendorMasters < ActiveRecord::Migration[7.1]
  def change
    create_table :vendor_masters do |t|
      t.string :customer_name
      t.string :customer_code
      t.integer :corporate_number
      t.integer :invoice_number

      t.timestamps
    end
  end
end
