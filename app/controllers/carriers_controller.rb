# Controller para mostrarle a un transportista una lista de publicaciones de envios y permitirle filtrarlas.
class CarriersController < ApplicationController

  before_action :authenticate_carrier!
  before_action :set_cache_headers, only: [:index, :show, :pending_shipments, :delivered_shipments, :scorings, :ecarriers_app]
  before_action :set_carrier, only: [:index, :show, :pending_shipments, :delivered_shipments, :scorings, :ecarriers_app]

  helper_method :should_show_bid_button, :should_show_trip_button, :get_carrier_bid

  # https://s3-sa-east-1.amazonaws.com/ecarriers/ecarriers_app_v1.apk

  # SIEMPRE PAR, para que quede bien el ciclo even odd (color de fondo)
  PUBLICATIONS_PER_PAGE = 16

  # GET /carriers(.:format)
  # Todas las publicaciones, paginadas y filtradas. Ajax call en app/assets/application/application.js
  def index
    @carrier = current_carrier
    @parent_categories = Category.parent_categories
    @shipment_publications = ShipmentPublication.
        where(accepted_bid: nil)

    filters = filtering_params(params)
    if filters and !filters.empty?
      # Filtros no vacíos
      @shipment_publications = eager_loaded_publications
      if origin_present?(filters) and destination_present?(filters)
        @shipment_publications = @shipment_publications.origin_destination(
            filters[:origin_city_name],
            filters[:origin_region_name],
            filters[:origin_country_name],
            filters[:destination_city_name],
            filters[:destination_region_name],
            filters[:destination_country_name]
        )
      elsif origin_present?(filters)
        @shipment_publications = @shipment_publications.origin(
            filters[:origin_city_name],
            filters[:origin_region_name],
            filters[:origin_country_name]
        )
      elsif destination_present?(filters)
        @shipment_publications = @shipment_publications.destination(
            filters[:destination_city_name],
            filters[:destination_region_name],
            filters[:destination_country_name]
        )
      elsif location_descriptions_present?(filters)
        @shipment_publications = @shipment_publications.location_descriptions(
            filters[:origin_description],
            filters[:destination_description]
        )
      elsif filters[:origin_description].present?
        @shipment_publications = @shipment_publications.origin_description(
            filters[:origin_description]
        )
      elsif filters[:destination_description].present?
        @shipment_publications = @shipment_publications.destination_description(
            filters[:destination_description]
        )
      end

      if filters[:categories].present?
        @shipment_publications = @shipment_publications.categories(filters[:categories])
      end

      @shipment_publications = @shipment_publications.
          paginate(page: params[:page], per_page: PUBLICATIONS_PER_PAGE).
          order('shipment_publications.created_at DESC')

    else
      # Filtros vacíos
      @shipment_publications = all_publications
    end

    respond_to do |format|
      format.html { render layout: 'carrier_dashboard_layout' }
      format.js { render layout: 'carrier_dashboard_layout' }
    end
  end

  # GET /carriers/:id(.:format)
  # Muestra la página de una publicación en particular
  def show
    @shipment_publication = eager_loaded_publication(params[:id])
    @bid = get_carrier_bid(@shipment_publication)

    respond_to do |format|
      if @shipment_publication.canceled?
        format.html {redirect_to carriers_path, flash: {error: 'No existe la publicación.' }}
      else
        format.html { render layout: 'carrier_dashboard_layout' }
      end
    end
  end

  def pending_shipments
    @title = 'Envíos pendientes'
    
    @pending_shipments = ShipmentPublication.ready_to_ship current_carrier

    render 'carrier_shipment_publications', layout: 'carrier_dashboard_layout'
  end

  def delivered_shipments
    @title = 'Envíos realizados'
    
    @pending_shipments = ShipmentPublication.carrier_has_delivered_it current_carrier
    
    render 'carrier_shipment_publications', layout: 'carrier_dashboard_layout'
  end

  def scorings
    @carrier_scorings = CarrierScoring.joins(:shipment_publication).where(shipment_publications: { carrier_id: @carrier.id })
    render 'scorings', layout: 'carrier_dashboard_layout'
  end

  def ecarriers_app
    render 'ecarriers_app', layout: 'carrier_dashboard_layout'
  end

  def download_apk
    redirect_to 'https://s3-sa-east-1.amazonaws.com/ecarriers/ecarriers_app_v1.apk'
  end

  private

  def get_carrier_bid(shipment_publication)
    carrier_bid = nil
    shipment_publication.bids.each do |bid|
      if bid.carrier.id == current_carrier.id
        carrier_bid = bid
        break
      end
    end
    carrier_bid
  end

  def should_show_bid_button
    !@shipment_publication.has_an_accepted_bid?
  end

  def should_show_trip_button
    @shipment_publication.has_an_accepted_bid?
  end

  def all_publications
    eager_loaded_publications.
        paginate(page: params[:page], per_page: PUBLICATIONS_PER_PAGE).
        order('shipment_publications.created_at DESC')
  end

  # Retorna un objeto ActiveRecord::Relation, no un Array de registros. Al resultado de este metodo
  # se le pueden encadenar otros finders de active record.
  def eager_loaded_publications
    ShipmentPublication.includes(
        :client,
        :category,
        :pickup_service_condition,
        :delivery_service_condition,
        bids: [:carrier],
        pickup_address: {city: [:country, region: :country]},
        delivery_address: {city: [:country, region: :country]}).
        where(accepted_bid: nil, canceled: false)
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
        find(id)
  end

  # A list of the param names that can be used for filtering the ShipmentPublication list
  def filtering_params(params)
    categories = nil
    categories = JSON.parse(params[:categories]) if params[:categories]
    categories.collect! { |id| id.to_i if id } if categories
    origin = nil
    origin = JSON.parse(params[:origin]) if params[:origin]
    destination = nil
    destination = JSON.parse(params[:destination]) if params[:destination]

    filtering_params = Hash.new
    if categories
      filtering_params[:categories] = categories
    end
    if origin
      filtering_params[:origin_description] = origin['description']
      filtering_params[:origin_city_name] = origin['city_name']
      filtering_params[:origin_region_name] = origin['region_name']
      filtering_params[:origin_country_name] = origin['country_name']
    end
    if destination
      filtering_params[:destination_description] = destination['description']
      filtering_params[:destination_city_name] = destination['city_name']
      filtering_params[:destination_region_name] = destination['region_name']
      filtering_params[:destination_country_name] = destination['country_name']
    end
    filtering_params
  end

  def origin_present?(filtering_params)
    filtering_params[:origin_city_name].present? and
        filtering_params[:origin_region_name].present? and
        filtering_params[:origin_country_name]
  end

  def destination_present?(filtering_params)
    filtering_params[:destination_city_name].present? and
        filtering_params[:destination_region_name].present? and
        filtering_params[:destination_country_name]
  end

  def location_descriptions_present?(filtering_params)
    filtering_params[:origin_description].present? and filtering_params[:destination_description].present?
  end

  def set_carrier
    @carrier = current_carrier
  end
end
