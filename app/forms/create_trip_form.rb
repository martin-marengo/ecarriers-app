class CreateTripForm < AbstractForm
  def initialize(params)
    super(params)
    
    @store_location_service = StoreLocationService.new
  end
  
  # @return [City]
  def origin
    origin_city_form = CityForm.new(trip_params[:origin])
    origin = @store_location_service.call origin_city_form
    
    return origin
  end

  # @return [City]
  def destination
    destination_city_form = CityForm.new(trip_params[:destination])
    destination = @store_location_service.call destination_city_form
  
    return destination
  end

  # @return [Date|nil]
  def departure_date
    DateTime.parse(trip_params[:departure_date]) rescue nil
  end

  # @return [Date|nil]
  def arrival_date
    DateTime.parse(trip_params[:arrival_date]) rescue nil
  end
  
  def shipment_publications
    ShipmentPublication.where(id: trip_params[:shipment_publication_ids])
  end

  private
  def trip_params
    @params.require(:trip)
  end
end