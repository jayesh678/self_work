Rails.application.routes.draw do
  devise_for :users, :path => 'u', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get '/enter_company_code', to: 'users/sessions#enter_company_code', as: :enter_company_code
  post '/process_company_code', to: 'users/sessions#process_company_code', as: :process_company_code
    # get 'enter_user_code', to: 'users/sessions#enter_user_code' # Add this line inside the devise_scope block
    # post 'process_user_code', to: 'users/sessions#process_user_code' 
  end

  resources :vendor_masters
  resources :business_partners do
    get 'fetch_customer_details', on: :collection
  end
 
  resources :users do
    resources :expenses do
      put 'approve', on: :member
      put 'cancel', on: :member
      resources :flows
    end
  end    

  resources :categories



  root "expenses#index"
end
