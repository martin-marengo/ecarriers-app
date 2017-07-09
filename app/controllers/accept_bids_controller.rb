class AcceptBidsController < ApplicationController
  before_action :authenticate_client!
  
  def initialize(
    accepted_bid_service = AcceptedBidService.new
  )
    super()
    
    @accepted_bid_service = accepted_bid_service
  end

  # GET /accepted_bids/new
  def new
    @bid = Bid.find(params[:bid_id])
  end

  # POST /accepted_bids
  # POST /accepted_bids.json
  def create
    bid = Bid.find(accept_bid_params)
    
    @accepted_bid_service.accept_bid bid
    
    # Reload page (we do this because this action takes place in a modal window it's more
    # simple than using ajax to refresh the page)
    redirect_to shipment_publication_url(bid.shipment_publication),
                notice: '¡La oferta se ha aceptado correctamente!'
  end

  private
  def accept_bid_params
    params.require(:bid).permit(:id)[:id]
  end
end
