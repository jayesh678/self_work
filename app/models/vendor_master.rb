class VendorMaster < ApplicationRecord
    has_many :business_partners, dependent: :destroy

    def self.fetch_customer_details(customer_name)
        # Implement logic to fetch details based on the customer name
        # Example:
        customer_info = find_by(customer_name: customer_name)
        {
          customer_code: customer_info.customer_code,
          corporate_number: customer_info.corporate_number,
          invoice_number: customer_info.invoice_number,
          # Add other fields as needed
        }
      end
end
