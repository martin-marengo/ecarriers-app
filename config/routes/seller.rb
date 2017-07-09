devise_for :sellers, controllers: { registrations: 'sellers/registrations' }

resources :api_tokens, only: [:index, :create, :new, :destroy]

# Ruta del link de confirmación de registro de carrier
devise_scope :carrier do
  get 'carrier/confirm/:confirmation_token', to: 'devise/confirmations#show', as: :carrier_confirm
end


# Ruta del link de confirmación de registro de seller
devise_scope :seller do
  get 'seller/confirm/:confirmation_token', to: 'devise/confirmations#show', as: :seller_confirm
end