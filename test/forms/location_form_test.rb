require 'test_helper'

class LocationFormTest < ActiveSupport::TestCase

  test 'Address' do
    expected_address = correct_address
    location = well_formed_location_form
    
    assert_equal expected_address.attributes, location.address.attributes
    assert_equal expected_address.city.attributes, location.city.attributes
    assert_equal expected_address.city.region.attributes, location.region.attributes
    assert_equal expected_address.city.region.country.attributes, location.country.attributes
  end
  
  private
  
  # A well initialized location form
  def well_formed_location_form
    address = correct_address
    
    address_params = {}
    address_params[:street_name] = address.street_name
    address_params[:street_number] = address.street_number
    address_params[:floor_number] = address.floor_number
    address_params[:apartment] = address.apartment
    address_params[:location_description] = address.location_description
    address_params[:lat] = address.lat
    address_params[:lng] = address.lng

    location_params = {}
    location_params[:country_name] = address.city.region.country.name
    location_params[:country_code] = address.city.region.country.code
    location_params[:region_name] = address.city.region.name
    location_params[:city_name] = address.city.name

    return LocationForm.new address_params, location_params
  end
end
