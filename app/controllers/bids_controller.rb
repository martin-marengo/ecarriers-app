class BidsController < ApplicationController

  before_action :set_bid, only: [:edit, :update, :destroy]
  before_action :set_current_carrier, only: [:index, :pending]
  before_action :authenticate_carrier!
  before_action :set_cache_headers, only: [:index, :pending]

  # SIEMPRE PAR, para que quede bien el ciclo even odd (color de fondo)
  BIDS_PER_PAGE = 16

  # Todas las ofertas, ordenadas en forma descendente de mas nueva a mas antigua.
  def index
    @bids = all_bids
    @title = 'Mis ofertas'

    respond_to do |format|
      format.html { render layout: 'carrier_dashboard_layout' }
      format.js { render layout: 'carrier_dashboard_layout' }
    end
  end

  def new
    shipment_publication = ShipmentPublication.find(params[:shipment_publication_id])
    
    @bid = Bid.new(carrier_id: current_carrier.id, shipment_publication_id: shipment_publication.id)
  end

  # Ofertas pendientes de aprobación o no, ordenadas en forma descendente de mas nueva a mas antigua.
  def pending
    @bids = pending_bids
    @title = 'Ofertas pendientes'
  
    render 'index', layout: 'carrier_dashboard_layout'
  end

  def edit
  end

  def create
    @bid = Bid.new(bid_params)

    respond_to do |format|
      if @bid.save
        BidsMailer.created(@bid, @bid.shipment_publication.client).deliver_later
        
        format.js { flash.now[:success] = 'La oferta se ha creado con éxito' }
      else
        format.js
      end
    end
  end

  def update
    respond_to do |format|
      if @bid.update(bid_params)
        BidsMailer.updated(@bid, @bid.shipment_publication.client).deliver_later
        
        format.js { flash.now[:success] = 'La oferta se ha modificado con éxito' }
      else
        format.js
      end
    end
  end

  # DELETE /bids/1
  def destroy
    @bid.destroy
    
    respond_to do |format|
      BidsMailer.canceled(@bid, @bid.shipment_publication.client).deliver_later
      
      format.js { flash.now[:success] = 'Has cancelado tu oferta' }
    end
  end

  private
  def set_bid
    @bid = Bid.find(params[:id])
  end

  def bid_params
    bid_parameters = params.require(:bid).permit(:description, :price, :carrier_id, :shipment_publication_id)
    
    # Transform to float, because Bid.money does not support a string value
    bid_parameters[:price] = bid_parameters[:price].to_f
    
    return bid_parameters
  end

  # Get all the current Carrier's bids
  # @return [Array<Bid>]
  def all_bids
    eager_loaded_bids.paginate(page: params[:page], per_page: BIDS_PER_PAGE).order('bids.created_at DESC')
  end

  # Get all the current carrier's pending bids
  # @return [Array<Bid>]
  def pending_bids
    Bid.
      includes(:carrier, :shipment_publication).
      joins(:shipment_publication).
      where(carrier: current_carrier).
      where(shipment_publications: {accepted_bid_id: nil}).
      paginate(page: params[:page], per_page: BIDS_PER_PAGE).
      order('bids.created_at DESC')
  end

  # Do an eager load of current Carrier's bids (And get them)
  # @return [Array<Bid>]
  def eager_loaded_bids
    Bid.includes(:carrier, :shipment_publication).where(carrier: current_carrier)
  end

  def set_current_carrier
    if current_carrier
      @carrier = current_carrier
    else
      redirect_to new_carrier_session_path, notice: 'No ha iniciado sesión.'
    end
  end
end
