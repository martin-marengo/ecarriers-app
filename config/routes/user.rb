devise_for :users, controllers: { registrations: 'users/registrations', omniauth_callbacks: 'omniauth_callbacks' }


resources :shipment_publication do
  member do
    post :item_info
  end
end
resources :shipment_publication, only: [:show, :index]


resources :user_trip_publications do
  collection do
    get :my_publications
  end
  member do
    post :set_visible
    post :set_not_visible
  end
end
resources :user_trip_publications
get 'user_trip_publications/show_own/:id', to: 'user_trip_publications#show_own', as: :show_own_user_trip_publication


resources :shipment_requests, only: [:create, :update, :destroy] do
  resources :budgets, except: [:index, :show] do
    member do
      post :accept
    end 
  end
end


# Ruta del link de confirmación de registro de user
devise_scope :user do
  get 'user/confirm/:confirmation_token', to: 'devise/confirmations#show', as: :user_confirm
  get '/users/:id/finish_omniauth_signup' => 'users/registrations#finish_omniauth_signup', as: :finish_omniauth_signup
  patch '/users/:id/finish_omniauth_signup' => 'users/registrations#update_omniauth_user', as: :update_omniauth_user
end