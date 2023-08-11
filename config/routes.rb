Rails.application.routes.draw do
  
  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }
  
  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }
  
  root to: 'public/homes#top'
  
  namespace :admin do
    resources :users, only: [:index, :show, :destroy]
    resources :post_records, only: [:index, :show, :destroy] do
      resources :comments, only: [:create, :destroy]
    end
    resources :categories, only: [:index, :create, :edit, :update, :destroy]
  end

  scope module: :public do
    resources :users, only: [:index, :show, :edit, :update]
    resources :post_records do
      resources :favorites, only: [:index, :create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
    get 'homes/calendar' => 'homes#calendar'
  end
  
  devise_scope :user do
    post 'users/guest_sign_in', to: 'public/sessions#guest_sign_in'
  end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
