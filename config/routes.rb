Rails.application.routes.draw do
  devise_for :users, controllers: { passwords: "users/passwords" }
  root "posts#index"

  scope controller: :follows do
    post "/follow/:id" => :follow, as: "follow_user"
    get "/follow/:id/followers" => :follower, as: "followers_user"
    get "/follow/:id/followings" => :following, as: "followings_user"
    put "/follow/:id/approve" => :approve_toggle, as: "approve_follower"
  end

  scope controller: :blocks do
    post "/users/:id/block" => :block_toggle, as: "block_user"
    get "/users/blocks" => :blocked_user, as: "blocks"
  end

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
      put "archive" => "posts#archive_post"
      post "save" => "posts#save_post"
    end

    collection do
      get "like" => "posts#liked"
      get "mypost" => "posts#mypost"
    end
  end

  resources :archives, only: [:index, :destroy] do
    member do
      delete "unsave" => "archives#destroy_saved_post"
    end

    collection do
      get "saved" => "archives#saved_post"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
