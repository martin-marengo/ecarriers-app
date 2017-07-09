# A separate object which represents user input.
# It handles the parsing and validating the input format, freeing the service from doing it.
# It’s useful to decouple parsing complex params from actually performing work in the service.
# https://www.netguru.co/blog/service-objects-in-rails-will-help

class LocationForm

  attr_reader :location_params
  attr_reader :address_params

  def initialize(address_params, location_params)
    @address_params = address_params
    @location_params = location_params
  end

  def country
    Country.new(
        name: @location_params[:country_name],
        code: @location_params[:country_code]
    )
  end

  def region
    Region.new(
        name: @location_params[:region_name],
        country: country
    )
  end

  def city
    City.new(
        name: @location_params[:city_name],
        region: region,
        country: country
    )
  end

  # @return [Address]
  def address
    if @address_params
      Address.new(
          street_name: @address_params[:street_name],
          street_number: @address_params[:street_number],
          floor_number: @address_params[:floor_number],
          apartment: @address_params[:apartment],
          lat: @address_params[:lat],
          lng: @address_params[:lng],
          location_description: @address_params[:location_description],
          city: city
      )
    else
      return nil
    end
  end

  def has_a_region?
    !region.name.strip.empty?
  end

end