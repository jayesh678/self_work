class Users::SessionsController < Devise::SessionsController
  def after_sign_in_path_for(resource)
    if resource.company_code.nil?
      enter_company_code_path
    else
      root_path
    end
  end
end
