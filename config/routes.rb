Rails.application.routes.draw do
  root to: 'restaurants#index'
  resources :restaurants, only: :index
  get 'restaurants/search' => "restaurants#search"
  get 'restaurants/data' => "restaurants#data"
end
