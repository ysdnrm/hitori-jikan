Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  resources :users, only: [:index, :show, :edit, :update]
  resources :posts do
    resources :post_comments, only: [:create, :destroy]
        # post_imagesと親子関係（「親」に対して「子」される）
        # ⇩ resourceとなっている点に注目!(単数形にすると、/:idがURLに含まれなくなる。)
    # resource :favorites, only: [:create, :destroy]
        # ↑ ネストする(params[:post_image_id]でPostImageのidが取得できるようになります。)
  end
  
  # タグの検索で使用する
  get "search_tag" => "posts#search_tag"
  
  
  
  

end
