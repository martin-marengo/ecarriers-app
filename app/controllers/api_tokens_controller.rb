class ApiTokensController < ApplicationController
  before_action :authenticate_seller!
  
  def initialize
    super()
    
    @token_service = TokenService.new
  end

  # GET /api_tokens
  def index
    unless current_seller.has_api_token? 
      redirect_to action: :new
      return
    end
    
    @token = current_seller.api_token
  end

  # GET /api_tokens/new
  def new
    # If seller has a token, redirect to index
    redirect_to action: :index if current_seller.has_api_token? 
  end
  
  # POST /api_tokens
  def create
    @token_service.assign_token(current_seller)
    
    respond_to do |format|
        format.js { render :create, locals: {token: current_seller.api_token} }
    end
  end

  # DELETE /api_tokens/1
  def destroy
    @token_service.remove_token(current_seller)

    respond_to do |format|
      format.html { redirect_to shipment_publications_url, notice: 'Se ha eliminado el Token de la API correctamente' }
    end
  end
end
