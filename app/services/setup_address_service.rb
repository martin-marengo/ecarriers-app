class SetupAddressService

  def initialize
    @store_location_service = StoreLocationService.new
  end

  # Save or retrieve all Address data related to city, region and country. This method DO NOT save the address
  # @param [LocationForm] location_form
  # @return [Address] Complete Address, with correct saved city, region and country
  def call(location_form)
    saved_city = @store_location_service.call(location_form)
    
    address = location_form.address
    if address
      address.city = saved_city
      address.region = saved_city.try(:region)

      saved_country = get_saved_country(saved_city)
      address.country = saved_country
    end
    
    return address
  end

  private

  # @param [City] saved_city
  # @return [Country] saved_country
  def get_saved_country(saved_city)
    saved_country = saved_city.try(:country)
    saved_country ||= saved_city.try(:region).try(:country)
    
    return saved_country
  end

end