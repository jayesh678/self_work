# app/forms/user_code_form.rb
class UserCodeForm
    include ActiveModel::Model
  
    attr_accessor :user_code
  
    validates :user_code, presence: true
  
    # Add any other validations or logic as needed
  end
  