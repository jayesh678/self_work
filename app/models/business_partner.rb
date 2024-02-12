class BusinessPartner < ApplicationRecord
    belongs_to :vendor_master
    has_many :expenses
    has_many :travel_expenses
    validates :customer_code, presence: true
    validates :corporate_number, presence: true
end
