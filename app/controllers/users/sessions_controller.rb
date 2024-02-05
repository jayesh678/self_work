# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
    before_action :authenticate_user!, except: [:new, :create, :enter_company_code, :process_company_code]
  
    def new
      super
    end
  
    def create
      self.resource = warden.authenticate!(auth_options)
      sign_in(resource_name, resource)
      yield resource if block_given?
  
      # Redirect to the enter_company_code path after successful login
      redirect_to enter_company_code_path
    end
  
    def enter_company_code
      # Logic to check if the user has already entered the company code
      if current_user.company_code.present?
        redirect_to root_path, notice: "You have already entered the company code."
      end
    end
  
    
  def process_company_code
    code = params[:user][:company_code]
    user_company = current_user.company

    if valid_company_code?(user_company, code)
      redirect_to root_path, notice: "Company code entered successfully."
    else
      flash.now[:alert] = "Invalid company code. Please try again."
      render :enter_company_code
    end
  end

  private

  def valid_company_code?(user_company, code)
    # Check if the entered code matches the company's code
    user_company&.company_code == code
  end
  end
  