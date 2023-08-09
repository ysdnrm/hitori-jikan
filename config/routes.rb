Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  get '/about' => 'homes#about', as: 'about'
  
  resources :posts, only: [:new, :create, :index, :show, :destroy] do
        # post_imagesと親子関係（「親」に対して「子」される）
        # ⇩ resourceとなっている点に注目!(単数形にすると、/:idがURLに含まれなくなる。)
    # resource :favorites, only: [:create, :destroy]
    # resources :post_comments, only: [:create, :destroy]
        # ↑ ネストする(params[:post_image_id]でPostImageのidが取得できるようになります。)
  end
  
  resources :users, only: [:show, :edit, :update]

end
