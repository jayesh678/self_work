class ApplicationController < ActionController::Base
  before_action :authenticate_user! 
  before_action :configure_permitted_parameters, if: :devise_controller? 

  def enter_company_code
    if current_user.company_code.present?
      redirect_to root_path, notice: "You have already entered the company code."
    end
  end

  def update_company_code
    if current_user.update(company_code: params[:user][:company_code])
      redirect_to root_path, notice: "Company code updated successfully."
    else
      flash.now[:alert] = "Failed to update company code."
      render :enter_company_code
    end
  end
  private
  def configure_permitted_parameters 
  devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :password, :password_confirmation, :firstname, :lastname, :role_id, :company_id]) 
  end 
end 
  