Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'auth/v1/user'

  namespace :admin do
    namespace :v1 do
      get "home" => "home#index"
      resources :categories, :users, :coupons, :system_requirements, :products
      resources :games, only: [], shallow: true do
        resources :licenses
      end
    end
  end

  namespace :storefront do
    namespace :v1 do
    end
  end
end
