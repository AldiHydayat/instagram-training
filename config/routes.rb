Rails.application.routes.draw do
  devise_for :users
  root "posts#index"

  post "/users/:id/follow", to: "follows#follow", as: "follow_user"
  get "/users/:id/followers", to: "follows#follower", as: "followers_user"
  get "/users/:id/followings", to: "follows#following", as: "followings_user"
  put "/users/:id/approve", to: "follows#approve_toggle", as: "approve_follower"

  resources :posts do
    resources :comments, only: [:create] do
      member do
        post "reply" => "comments#reply"
      end
    end

    member do
      put "like_toggle" => "posts#like_toggle"
      get "user" => "posts#get_by_user"
      post "repost" => "posts#repost"
    end

    collection do
      get "like" => "posts#liked"
      get "mypost" => "posts#mypost"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
