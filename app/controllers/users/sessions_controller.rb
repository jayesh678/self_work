class Users::SessionsController < Devise::SessionsController
  before_action :authenticate_user!, except: [:new, :create, :enter_company_code, :process_user_code]

  def new
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    yield resource if block_given?

    # Redirect to the enter_user_code_path after successful login
    redirect_to enter_user_code_path
  end

  def enter_user_code
    # Always render the form for users to enter their unique user code
    @user_code_form = UserCodeForm.new # Assuming you have a form object for handling user code input
  
    # You can also pass other necessary data to the form, such as company details or user preferences
    # For example:
    # @company = current_user.company
  
    render :enter_user_code
  end

  def process_user_code
    user_code = params[:user_code]
    current_user.user_code = user_code

    if current_user.save
      redirect_to root_path, notice: "User code entered successfully."
    else
      flash.now[:alert] = "Failed to save user code. Please try again."
      render :enter_user_code
    end
  end

  def enter_company_code
    # Logic to check if the user has already entered the company code
    if current_user.company_code.present?
      redirect_to root_path, notice: "You have already entered the company code."
    end
  end

  def process_user_code
    user_code = params[:user_code]
  
    # Skip the uniqueness validation if the user code being updated is the same as the current user's user code
    if current_user.user_code == user_code
      current_user.save(validate: false)
    else
      current_user.user_code = user_code
      current_user.save
    end
  
    redirect_to root_path, notice: "User code entered successfully."
  end
  
  
  private

  def valid_company_code?(user_company, code)
    # Check if the entered code matches the company's code
    user_company&.company_code == code
  end
end