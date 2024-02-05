class AddVendorMasterRefToBusinessPartners < ActiveRecord::Migration[7.1]
  def change
    add_reference :business_partners, :vendor_master, null: true, foreign_key: true
  end
end
