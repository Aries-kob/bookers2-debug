Rails.application.routes.draw do
  get 'book_comments/create'
  get 'book_comments/destroy'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: "homes#top"
  get "home/about"=>"homes#about"
  devise_for :users

  resources :books, only: [:index,:show,:edit,:create,:destroy,:update]do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy]
  end  
  resources :users, only: [:index,:show,:edit,:update]do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end  
  get "search" => "searches#search"
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
 end
