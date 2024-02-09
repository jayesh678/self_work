class BusinessPartner < ApplicationRecord
    belongs_to :vendor_master
    validates :customer_code, presence: true
    validates :corporate_number, presence: true
end
