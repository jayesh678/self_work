Rails.application.routes.draw do
  devise_for :users, :path => 'u', controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get 'enter_company_code', to: 'users/sessions#enter_company_code'
    post 'process_company_code', to: 'users/sessions#process_company_code'
  end

  resources :vendor_masters do
    resources :business_partners do
      get 'fetch_customer_details', on: :collection
    end
  end
 
  resources :users do
    resources :expenses
  end    

  resources :categories
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  root "expenses#index"

  # Defines the root path route ("/")
  # root "posts#index"
end
