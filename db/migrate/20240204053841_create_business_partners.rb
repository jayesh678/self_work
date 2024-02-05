class CreateBusinessPartners < ActiveRecord::Migration[7.1]
  def change
    create_table :business_partners do |t|
      t.string :customer_name
      t.string :customer_code
      t.integer :corporate_number
      t.integer :invoice_number
      t.string :address
      t.integer :postal_code
      t.integer :telephone_number
      t.string :bank_name

      t.timestamps
    end
  end
end
