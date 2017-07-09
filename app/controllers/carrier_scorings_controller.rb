class CarrierScoringsController < ApplicationController

  before_action :authenticate_client!
  before_action :set_cache_headers
  
  def new
    @carrier_scoring = CarrierScoring.new
    @shipment_publication = ShipmentPublication.find_by_id(params[:id])
    
    unless can_score_carrier @shipment_publication
      redirect_unauthorized shipment_publications_url
    end
  end
  
  def create
    @shipment_publication = ShipmentPublication.find(carrier_scoring_params[:shipment_publication_id])
    unless can_score_carrier @shipment_publication
      redirect_unauthorized shipment_publications_url
      return
    end
    
    @carrier_scoring = CarrierScoring.new(carrier_scoring_params)

    respond_to do |format|
      if @carrier_scoring.save
        format.html { redirect_to get_successful_redirect_url(@carrier_scoring),
                                  notice: '¡Tu calificación se ha guardado!' }
      else
        format.html { render :new }
      end
    end
  end

  private
  
  def can_score_carrier(shipment_publication)
    shipment_publication.client == current_client and
      shipment_publication.can_score_carrier
  end

  # @param [CarrierScoring] carrier_scoring
  def get_successful_redirect_url(carrier_scoring)
    url_for controller: 'shipment_publications', action: :show, id: carrier_scoring.shipment_publication.id
  end
  
  def carrier_scoring_params
    params.require(:carrier_scoring).permit(:shipment_publication_id, :service_quality, :delivery_time, :feedback, :recommended)
  end
end
