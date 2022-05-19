# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  resources :captions, :instagram_captions

  get '/images/:id', to: 'images#show'

  post '/signup', to: 'users#create'
  post '/login', to: 'users#login'
end
