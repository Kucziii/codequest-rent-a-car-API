Rails.application.routes.draw do
  mount Knock::Engine => '/auth'

    resources :users
    post '/rentals' => 'api/v1/rentals#rent_a_car'
    post 'user_token' => 'user_token#create'
end
