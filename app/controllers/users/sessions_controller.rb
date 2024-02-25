# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
    before_action :authenticate_user!, except: [:new, :create, :enter_company_code, :process_company_code]

  
    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
      
      # Redirect to the enter_company_code_path after successful login
      redirect_to enter_company_code_path
    end
    
    def enter_company_code
      # Redirect to enter_company_code_path if the current page is not already enter_company_code_path
      redirect_to enter_company_code_path unless request.path == enter_company_code_path
    end
    
    

  def process_company_code
    company_code = params[:user][:company_code]
    user_company = current_user.company

    if valid_company_code?(user_company, company_code)
      session[:company_code_entered] = true
      redirect_to root_path, notice: "Company code entered successfully."
    else
      flash.now[:alert] = "Invalid company code. Please try again."
      render :enter_company_code
    end
  end

  private

  def valid_company_code?(user_company, company_code)
    # Check if user_company is present and if the entered code matches the company's code
    user_company.present? && user_company.company_code == company_code
  end
  
  
  end
  
