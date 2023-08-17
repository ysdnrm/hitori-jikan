Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  
  resources :users, only: [:index, :show, :edit, :update] do
    # いいねした投稿一覧
    member do
      get :favorites
    end
  end
  
  resources :posts do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  
  # タグの検索で使用する
  get "search_tag" => "posts#search_tag"
  
  
  
  

end
