Rails.application.routes.draw do
  
  namespace :api do
    namespace :v1 do
      post "/login", to: "access_tokens#create"
      delete "/logout", to: "access_tokens#destroy"
      post "/sign_up", to: "registration#create"
      
      resources :articles do
        resources :comments, only: [:create, :index]
      end
    end
  end
end
