require 'faker'

namespace :submit_data do
  desc 'Submit actual data to the application and fetch from VendorMaster'
  task :actual_data => :environment do
    vendor_masters = []

    last_corporate_number = VendorMaster.maximum(:corporate_number) || 0

    20.times do |index|
      corporate_number = last_corporate_number + index + 1

      vendor_master = VendorMaster.create(
        customer_name: Faker::Company.name,
        customer_code: "code#{index + 1}",
        invoice_number: index + 100,
        corporate_number: corporate_number
      )

      vendor_masters << vendor_master
    end

    puts 'Vendor Master records created successfully.'

    vendor_masters.each do |vendor_master|
      puts "Customer Name: #{vendor_master.customer_name}"
      puts "Customer Code: #{vendor_master.customer_code}"
      puts "Invoice Number: #{vendor_master.invoice_number}"
      puts "Corporate Number: #{vendor_master.corporate_number}"
      puts '-' * 30
    end
  end
end
