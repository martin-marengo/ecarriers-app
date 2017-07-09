devise_for :carriers, controllers: { registrations: 'carriers/registrations' }


resources :bids do
  collection do
    get :pending
  end
end
resources :bids


resources :carriers do
  collection do
    get :pending_shipments
    get :delivered_shipments
    get :scorings
    get :download_apk
    get :ecarriers_app
  end
end
resources :carriers, only: [:index, :show]

resources :carrier_statistics do
  collection do
    get :most_requested_destinations
    get :revenues
  end
end


resources :trips do
  member do
    patch 'mark_as_driving'
    patch 'mark_as_finished'
  end
  collection do
    get 'show_mark_as_driving'
    get 'show_mark_as_finished'
  end
end