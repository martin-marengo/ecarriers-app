# MainController routes
get '/main/index', to: 'main#index', as: 'main'

root to: 'main#index'

# Resources routes
resources :accept_bids, only: [:new, :create]
resources :carrier_scorings, only: [:new, :create]
resources :messages, only: [:create]
resources :location_reports, only: [:show]

resources :shipment_publications do
  member do
    get :carrier_view
    post :set_visible
    post :set_not_visible
  end
end
resources :shipment_publications, only: [:index, :show]

resources :conversations, only: [:create, :edit, :update, :delete] do
  member do 
    post :new_from_bid
    post :new_from_shipment_request
  end
end