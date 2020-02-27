Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:show,:index,:edit,:update] do
	resource :relationships, only: [:create, :destroy]
  end

  get 'relationships/follower' => 'relationships#follower', as: 'relationships_follower'
  get 'relationships/follow' => 'relationships#follow', as: 'relationships_follow'

  post 'search' => 'search#search', as: 'search'

  resources :books do
  	resource :book_comments, only: [:create, :destroy]
  	resource :favorites, only: [:create, :destroy]
  end

  root 'home#top'
  get 'home/about'

end
