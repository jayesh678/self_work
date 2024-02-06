class BusinessPartnersController < ApplicationController
  before_action :set_vendor_master, only: [:new, :create, :edit, :update, :destroy, :show]


  def index
    @vendor_master = VendorMaster.find(params[:vendor_master_id])
    @business_partners = @vendor_master.business_partners
  end
    def show
      @business_partner = @vendor_master.business_partners.find_by(id: params[:id])
      if @business_partner.nil?
        # Handle record not found, perhaps redirect to an error page or show a flash message
        flash[:alert] = 'Business Partner not found'
      end
    end


    def edit
      @business_partner = @vendor_master.business_partners.find(params[:id])
      @customer_names = VendorMaster.pluck(:customer_name)
    end

    def update
      @business_partner = @vendor_master.business_partners.find(params[:id])
  
      if @business_partner.update(business_partner_params)
        redirect_to vendor_master_business_partner_path(@vendor_master, @business_partner), notice: 'Business Partner was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @business_partner = @vendor_master.business_partners.find(params[:id])
      @business_partner.destroy
    end

  
    def new
      @vendor_master = VendorMaster.find(params[:vendor_master_id])
      @business_partner = @vendor_master.business_partners.build
      @customer_names = VendorMaster.pluck(:customer_name)
    end

  

    def create
      @vendor_master = VendorMaster.find(params[:vendor_master_id])
      @business_partner = @vendor_master.business_partners.build(business_partner_params)
    
      # Fetch additional information from Vendor Master based on selected customer_name
      selected_customer_name = params[:business_partner][:customer_name]
      vendor_info = VendorMaster.find_by(customer_name: selected_customer_name)
    
      # Check if vendor_info is not nil before accessing its attributes
      if vendor_info
        # Autofill information from Vendor Master
        @business_partner.customer_code = vendor_info.customer_code
        @business_partner.corporate_number = vendor_info.corporate_number
        @business_partner.invoice_number = vendor_info.invoice_number
      else
        # Handle the case where vendor_info is nil (e.g., display an error message or redirect)
        flash[:alert] = "Selected customer not found. Please choose a valid customer."
        render :new and return
      end
    
      if @business_partner.save
        # Redirect to the business partner index page
        redirect_to vendor_master_business_partners_path(@vendor_master), notice: "Business partner created successfully."
      else
        render :new
      end
    end
    
  
  # app/controllers/business_partners_controller.rb
  
  def fetch_customer_details
    customer_name = params[:customer_name]
    @customer_details = VendorMaster.find_by(customer_name: customer_name)
  
    respond_to do |format|
      format.js
    end
  end
  
    
    private
  
    def set_vendor_master
      @vendor_master = VendorMaster.find(params[:vendor_master_id])
    end
  
    def business_partner_params
      params.require(:business_partner).permit(:customer_name, :customer_code, :corporate_number, :invoice_number, :address, :postal_code, :telephone_number, :bank_name)
    end
  end
  