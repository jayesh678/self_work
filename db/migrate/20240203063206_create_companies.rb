class CreateCompanies < ActiveRecord::Migration[7.1]
  def change
    create_table :companies do |t|
      t.string :company_name
      t.string :company_code
      t.string :company_uniqueid

      t.timestamps
    end
  end
end
