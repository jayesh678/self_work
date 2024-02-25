class BusinessPartnersController < ApplicationController
  rescue_from CanCan::AccessDenied do |exception|
    render "shared/access_denied", status: :forbidden
  end
  load_and_authorize_resource
  before_action :set_vendor_master, only: [:new, :create, :edit, :update, :destroy, :show]


  def index
    @vendor_master = VendorMaster.find(params[:vendor_master_id])
    @business_partners = @vendor_master.business_partners
    @business_partners = @business_partners.paginate(page: params[:page], per_page: 2)
  end
    def show
      @business_partner = @vendor_master.business_partners.find_by(id: params[:id])
      if @business_partner.nil?
        flash[:alert] = 'Business Partner not found'
      end
    end


    def edit
      @business_partner = @vendor_master.business_partners.find(params[:id])
      @customer_names = VendorMaster.pluck(:customer_name) 
      puts "@customer_names in edit action: #{@customer_names.inspect}"
    end
    

    def update
      @business_partner = @vendor_master.business_partners.find(params[:id])
      @customer_names = VendorMaster.pluck(:customer_name) 
  
      if @business_partner.update(business_partner_params)
        redirect_to vendor_master_business_partner_path(@vendor_master, @business_partner), notice: 'Business Partner was successfully updated.'
      else
        render :edit
      end
    end

    def destroy
      @business_partner = @vendor_master.business_partners.find(params[:id])
      @business_partner.destroy
      respond_to do |format|
      format.html { redirect_to vendor_master_business_partners_path(@vendor_master), notice: 'Business Partner was successfully destroyed.' }
      format.json { head :no_content }
    end
    end

  
    def new
      @vendor_master = VendorMaster.find(params[:vendor_master_id])
      @business_partner = @vendor_master.business_partners.build
      @customer_names = VendorMaster.pluck(:customer_name)
      # puts "@customer_names = #{@customer_names.inspect}"
    end

  

    def create
      @vendor_master = VendorMaster.find(params[:vendor_master_id])
      @business_partner = @vendor_master.business_partners.build(business_partner_params)
       @customer_names = VendorMaster.pluck(:customer_name)
    
     
      selected_customer_name = params[:business_partner][:customer_name]
      vendor_info = VendorMaster.find_by(customer_name: selected_customer_name)
    
    
      if vendor_info
        @business_partner.customer_code = vendor_info.customer_code
        @business_partner.corporate_number = vendor_info.corporate_number
        @business_partner.invoice_number = vendor_info.invoice_number
      else
        
        flash[:alert] = "Selected customer not found. Please choose a valid customer."
        render :new and return
      end
    
      if @business_partner.save
        
        redirect_to vendor_master_business_partners_path(@vendor_master), notice: "Business partner created successfully."
      else
        render :new
      end
    end
    
  
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
  