Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "/login", to: "access_tokens#create"
      resources :articles, only: [:index, :show]
    end
  end
end
