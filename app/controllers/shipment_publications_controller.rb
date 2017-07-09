# Controller para mostrarle a un usuario las publicaciones que realizó
class ShipmentPublicationsController < ApplicationController
  before_action :authenticate_client!, :set_current_client
  before_action :set_shipment_publication, only: [:show, :destroy, :set_visible, :set_not_visible]
  before_action :validate_publication_ownership, only: [:destroy, :set_visible, :set_not_visible]

  helper_method :should_show_score_button, :should_show_location_report_button

  # SIEMPRE PAR, para que quede bien el ciclo even odd (color de fondo)
  CATEGORIES_PER_PAGE = 16
  BIDS_PER_PAGE = 4

  # GET /shipment_publications(.:format)
  def index
    @parent_categories = Category.parent_categories

    @shipment_publications = all_publications

    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET /shipment_publications/:id(.:format)
  def show
    respond_to do |format|
      format.html
      format.js
    end
  end

  # GET
  def carrier_view
    @shipment_publication = eager_loaded_publication(carrier_view_params[:id])
    @carrier = Carrier.find_by_id(carrier_view_params[:carrier_id])
    unless @carrier
      @carrier_scorings = CarrierScoring.joins(:shipment_publication).where(shipment_publications: { carrier_id: @carrier.id })
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    ActiveRecord::Base.transaction do
      accepted_bid_id = @shipment_publication.accepted_bid.try(:id)
      @shipment_publication.update_attribute(:accepted_bid, nil)
      if accepted_bid_id
        Bid.find(accepted_bid_id).destroy
      end
      @shipment_publication.destroy
    end

    respond_to do |format|
      if !ShipmentPublication.exists?(@shipment_publication)
        format.html { redirect_to shipment_publications_path, success: 'Tu publicación se eliminó correctamente.' }
      else
        format.html { redirect_to shipment_publication_path(@shipment_publication), flash: {error: 'No fue posible eliminar esta publicación.' } }
      end

    end
  end

  def set_visible
    @shipment_publication.update_attribute(:canceled, false)

    respond_to do |format|
      format.html { redirect_to shipment_publication_path(@shipment_publication),
                                notice: 'Has hecho tu publicación visible a los transportistas.' }
    end
  end

  def set_not_visible
    @shipment_publication.update_attribute(:canceled, true)

    respond_to do |format|
      format.html { redirect_to shipment_publication_path(@shipment_publication),
                                notice: 'Has ocultado tu publicación de los transportistas.' }
    end
  end

  private

  def should_show_score_button
    @shipment_publication.can_score_carrier
  end

  def should_show_location_report_button
    !@shipment_publication.trip.nil? and @shipment_publication.trip.is_driving?
  end

  def all_publications
    eager_loaded_publications.paginate(page: params[:page], per_page: CATEGORIES_PER_PAGE).
        order('shipment_publications.created_at DESC')
  end

  # Retorna un objeto ActiveRecord::Relation, no un Array de registros. Al resultado de este metodo
  # se le pueden encadenar otros finders de active record.
  def eager_loaded_publications
    ShipmentPublication.where(client: @client).includes(
        :client,
        :category,
        :pickup_service_condition,
        :delivery_service_condition,
        bids: [:carrier],
        pickup_address: {city: [:country, region: :country]},
        delivery_address: {city: [:country, region: :country]})
  end

  def eager_loaded_publication(id)
    ShipmentPublication.includes(
        :client,
        :category,
        :pickup_service_condition,
        :delivery_service_condition,
        bids: [:carrier],
        pickup_address: {city: [:country, region: :country]},
        delivery_address: {city: [:country, region: :country]}).
        where(client: current_client).
        find(id)
  end

  def eager_loaded_bids(shipment_publication)
    Bid.
        where(shipment_publication: shipment_publication).
        includes(:carrier, :conversation).
        paginate(page: params[:page], per_page: BIDS_PER_PAGE).order('bids.created_at DESC')
  end

  def set_current_client
    @client = current_client
  end

  def carrier_view_params
    params.permit(:id, :carrier_id)
  end

  def set_shipment_publication
    @shipment_publication = eager_loaded_publication(params[:id])
    @bids = eager_loaded_bids(@shipment_publication)
  end

  def validate_publication_ownership
    unless @client.same_as(@shipment_publication.client)
      redirect_to shipment_publications_path, flash: {error: 'No tienes acceso a una publicación de otro usuario.' }
    end
  end
end