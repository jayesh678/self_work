class VendorMastersController < ApplicationController
  before_action :set_vendor_master

  def show
    @business_partners = @vendor_master.business_partners
  end

  private

  def set_vendor_master
    @vendor_master = VendorMaster.find(params[:id])
  end
end
