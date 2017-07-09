class UserTripPublicationsController < ApplicationController
  before_action :authenticate_user!, :set_current_user
  before_action :set_cache_headers
  before_action :set_user_trip_publication, only: [:show, :show_own, :edit, :update, :destroy, :set_visible, :set_not_visible]
  before_action :validate_publication_ownership, only: [:edit, :update, :destroy, :set_visible, :set_not_visible]

  TRIPS_PER_PAGE = 16
  REQUESTS_PER_PAGE = 6

  def initialize(
      store_location_service = StoreLocationService.new,
      setup_shipment_request_service = SetupShipmentRequestService.new
  )
    super()

    @store_location_service = store_location_service
    @setup_shipment_request_service = setup_shipment_request_service
  end

  # Muestra a un usuario las publicaciones de viaje de otros y permite buscar y filtrarlas.
  def index
    @user_trip_publications = UserTripPublication.where(nil)

    filters = filtering_params(params)
    if filters and !filters.empty?
      # Filtros no vacíos
      @user_trip_publications = other_users_trips
      if origin_present?(filters) and destination_present?(filters)
        @user_trip_publications = @user_trip_publications.origin_destination(
            filters[:origin_city_name],
            filters[:origin_region_name],
            filters[:origin_country_name],
            filters[:destination_city_name],
            filters[:destination_region_name],
            filters[:destination_country_name]
        )
      elsif origin_present?(filters)
        @user_trip_publications = @user_trip_publications.origin(
            filters[:origin_city_name],
            filters[:origin_region_name],
            filters[:origin_country_name]
        )
      elsif destination_present?(filters)
        @user_trip_publications = @user_trip_publications.destination(
            filters[:destination_city_name],
            filters[:destination_region_name],
            filters[:destination_country_name]
        )
      elsif location_descriptions_present?(filters)
        @user_trip_publications = @user_trip_publications.location_descriptions(
            filters[:origin_description],
            filters[:destination_description]
        )
      elsif filters[:origin_description].present?
        @user_trip_publications = @user_trip_publications.origin_description(
            filters[:origin_description]
        )
      elsif filters[:destination_description].present?
        @user_trip_publications = @user_trip_publications.destination_description(
            filters[:destination_description]
        )
      end

      if departure_date_present?(filters)
        @user_trip_publications = @user_trip_publications.departure_date(filters[:departure_date])
      end

      @user_trip_publications = @user_trip_publications.
          paginate(page: params[:page], per_page: TRIPS_PER_PAGE).
          order('user_trip_publications.created_at DESC')

    else
      # Filtros vacíos
      @user_trip_publications = other_users_trips.paginate(page: params[:page], per_page: TRIPS_PER_PAGE).
          order('user_trip_publications.created_at DESC')
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # Muestra a un usuario sus propias publicaciones de viajes.
  def my_publications
    @user_trip_publications = eager_loaded_trips.where(user: @current_user).
        paginate(page: params[:page], per_page: TRIPS_PER_PAGE).
        order('user_trip_publications.created_at DESC')

    respond_to do |format|
      format.html
      format.js
    end
  end

  # Muestra a un usuario una publicación de otro usuario.
  def show
    if @current_user.same_as(@user_trip_publication.user)
      redirect_to show_own_user_trip_publication_path(@user_trip_publication)
    end

    # Get shipment_requests if exists and do new or edit action.
    @shipment_request = @setup_shipment_request_service.call @user_trip_publication.id, @current_user
  end

  # Muestra a un usuario una publicación propia.
  def show_own
    unless @current_user.same_as(@user_trip_publication.user)
      redirect_to @user_trip_publication
    end

    @shipment_requests = ShipmentRequest.includes(:budget, :user_trip_publication, :user)
                             .where(user_trip_publication: @user_trip_publication)
                             .paginate(page: params[:page], per_page: REQUESTS_PER_PAGE)
                             .order('shipment_requests.created_at DESC')
  end

  def new
    @user_trip_publication = UserTripPublication.new

    @user_trip_publication.build_origin_city
    @user_trip_publication.build_destination_city
  end

  def create
    @user_trip_publication = UserTripPublication.new(user_trip_publication_params)
    @user_trip_publication.user = @current_user

    set_cities

    respond_to do |format|
      if @user_trip_publication.save
        format.html { redirect_to show_own_user_trip_publication_path(@user_trip_publication), success: 'Se ha publicado tu viaje.' }
      else
        format.html { render :new }
      end
    end
  end

  def edit
  end

  def update
    set_cities

    respond_to do |format|
      if @user_trip_publication.update(user_trip_publication_params)
        format.html { redirect_to @user_trip_publication, success: 'Tu viaje se actualizó correctamente.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @user_trip_publication.destroy
    respond_to do |format|
      format.html { redirect_to my_publications_user_trip_publications_path, success: 'Tu viaje se eliminó correctamente.' }
    end
  end

  def set_visible
    @user_trip_publication.update_attribute(:canceled, false)

    respond_to do |format|
      format.html { redirect_to show_own_user_trip_publication_path(@user_trip_publication),
                                notice: 'Has hecho tu publicación visible a los demás usuarios.' }
    end
  end

  def set_not_visible
    @user_trip_publication.update_attribute(:canceled, true)

    respond_to do |format|
      format.html { redirect_to show_own_user_trip_publication_path(@user_trip_publication),
                                notice: 'Has ocultado tu publicación de los demás usuarios.' }
    end
  end

  private

  def set_user_trip_publication
    @user_trip_publication = UserTripPublication.find(params[:id])
  end

  def user_trip_publication_params
    params.require(:user_trip_publication).permit(:vehicle_description, :departure_date, :departure_time,
                                                  :arrival_date, :arrival_time, :origin_location_description,
                                                  :destination_location_description, :origin_lat, :origin_lng,
                                                  :destination_lat, :destination_lng)
  end

  # @param [Symbol] where :origin_city_attributes or :destination_city_attributes
  def city_params(where)
    params.require(:user_trip_publication).require(where).permit(:city_name, :region_name, :country_name)
  end

  def origin_city_location_form
    address_params = nil
    LocationForm.new(address_params, city_params(:origin_city_attributes))
  end

  def destination_city_location_form
    address_params = nil
    LocationForm.new(address_params, city_params(:destination_city_attributes))
  end

  def set_current_user
    @current_user = current_user
  end

  def validate_publication_ownership
    unless @current_user.same_as(@user_trip_publication.user)
      redirect_to my_publications_user_trip_publications_path, flash: {error: 'No tienes acceso a una publicación de otro usuario.' }
    end
  end

  def set_cities
    origin_city = @store_location_service.call origin_city_location_form
    destination_city = @store_location_service.call destination_city_location_form

    @user_trip_publication.origin_city_id = origin_city.id if origin_city.id
    @user_trip_publication.destination_city_id = destination_city.id if destination_city.id
  end

  def other_users_trips
    eager_loaded_trips.where.not(user: @current_user, canceled: true)
  end

  def eager_loaded_trips
    UserTripPublication.includes(:user, :origin_city, :destination_city)
  end

  # A list of the param names that can be used for filtering the UserTripPublication list
  def filtering_params(params)
    origin = nil
    origin = JSON.parse(params[:origin], symbolize_names: true) unless params[:origin].blank?
    destination = nil
    destination = JSON.parse(params[:destination], symbolize_names: true) unless params[:destination].blank?
    departure_date = nil
    departure_date = JSON.parse(params[:departure_date], symbolize_names: true) unless params[:departure_date].blank?

    filtering_params = Hash.new
    if origin
      filtering_params[:origin_description] = origin[:description]
      filtering_params[:origin_city_name] = origin[:city_name]
      filtering_params[:origin_region_name] = origin[:region_name]
      filtering_params[:origin_country_name] = origin[:country_name]
    end
    if destination
      filtering_params[:destination_description] = destination[:description]
      filtering_params[:destination_city_name] = destination[:city_name]
      filtering_params[:destination_region_name] = destination[:region_name]
      filtering_params[:destination_country_name] = destination[:country_name]
    end
    if departure_date
      filtering_params[:departure_date] = departure_date[:departure_date]
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

  def departure_date_present?(filtering_params)
    filtering_params[:departure_date].present?
  end
end
