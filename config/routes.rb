Rails.application.routes.draw do
  devise_for :users
  get "users" => redirect("/users/sign_up")
  # ゲストログイン
  devise_scope :user do
    post "users/guest_sign_in", to: "users/sessions#guest_sign_in"
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'

  resources :users, only: [:show, :edit, :update] do
    # いいねした投稿一覧
    member do
      get :favorites
    end
  end

  namespace :admin do
    resources :users, only: [:index, :destroy]
  end

  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]

    collection do
      get 'confirm' #下書き
      get 'search'
      get 'search_tag'
    end

  end

end
