Rails.application.routes.draw do
  mount Knock::Engine => '/auth'
    namespace :api do
      namespace :v1 do
        resources :users
      end
    end
    post '/rentals' => 'api/v1/rentals#rent_a_car'
    post 'user_token' => 'user_token#create'
end
