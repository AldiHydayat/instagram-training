Rails.application.routes.draw do
  devise_for :users
  root "posts#index"

  resources :posts do
  	resources :comments, only: [:create]

  	member do 
  		put "like" => "posts#like"
		get "user" => "posts#get_by_user"
  	end

  	collection do
  		get "like" => "posts#liked"
		get "mypost" => "posts#mypost"
  	end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
