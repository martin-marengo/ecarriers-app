require 'test_helper'

class StoreLocationServiceTest < ActiveSupport::TestCase

  test 'No data is saved' do
    location_form = well_formed_location_form
    
    assert_nil Country.find_by(name: location_form.address.country_name)
    assert_nil Region.find_by(name: location_form.address.region_name)
    assert_nil City.find_by(name: location_form.address.city_name)
    
    setup_address_service = SetupAddressService.new
    setup_address_service.call location_form

    # Check that data is saved
    assert_not_nil Country.find_by(name: location_form.address.country_name)
    assert_not_nil Region.find_by(name: location_form.address.region_name)
    assert_not_nil City.find_by(name: location_form.address.city_name)
  end

  test 'There are previous saved data' do
    address = addresses :jonas_salk
    
    # Get objects before save
    country_before_method_call = Country.find_by(name: address.city.country.name)
    region_before_method_call = Region.find_by(name: address.city.region.name)
    city_before_method_call = City.find_by(name: address.city.name)
    
    # Check that objects are saved
    assert_not_nil country_before_method_call
    assert_not_nil region_before_method_call
    assert_not_nil city_before_method_call
  
    setup_address_service = SetupAddressService.new
    setup_address_service.call well_formed_location_form

    # Check that objects are still saved
    country_after_method_call = Country.find_by(name: address.city.country.name)
    region_after_method_call = Region.find_by(name: address.city.region.name)
    city_after_method_call = City.find_by(name: address.city.name)

    assert_not_nil country_after_method_call
    assert_not_nil region_after_method_call
    assert_not_nil city_after_method_call

    # Object must not change after method call if they were saved
    assert_equal country_before_method_call, country_after_method_call
    assert_equal region_before_method_call, region_after_method_call
    assert_equal city_before_method_call, city_after_method_call
  end
  
  private
  
  # A well initialized location form
  def well_formed_location_form
    address_params = {}
    address_params[:street_name] = 'Some'
    address_params[:street_number] = 123
    address_params[:location_description] = 'City, Region, Country'
    address_params[:lat] = 50
    address_params[:lng] = 50

    location_params = {}
    location_params[:country_name] = 'Some Country'
    location_params[:country_code] = 'CR'
    location_params[:region_name] = 'Some Region'
    location_params[:city_name] = 'Some City'

    return LocationForm.new address_params, location_params
  end
end
