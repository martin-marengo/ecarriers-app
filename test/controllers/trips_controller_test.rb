require 'test_helper'

class TripsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:carrier]
  
    carrier = carriers(:one)
  
    sign_in carrier
  end
  
  test 'should get new' do
    get :new
  
    assert_response :success
  end

  test 'should show mark as driving' do
    get :show_mark_as_driving
  
    assert_response :success
    assert_not_nil assigns(:trips)
  end

  test 'should show mark as finished' do
    get :show_mark_as_driving
  
    assert_response :success
    assert_not_nil assigns(:trips)
  end
  
  test 'should create' do
    params = {
      origin: {
        location_description: 'San Francisco, Córdoba, Argentina',
        name: 'San Francisco',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      },
      destination: {
        location_description: 'Devoto, Córdoba, Argentina',
        name: 'Devoto',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      },
      departure_date: '26/02/2017',
      arrival_date: '26/02/2017',
      shipment_publication_ids: [shipment_publications(:one).id]
    }
    
    assert_difference('Trip.count') do
      post :create, trip: params
    end
    
    trip = Trip.last
    
    assert_equal Trip::STATUS_HAVE_TO_FETCH_ITEMS, trip.status
    assert_equal 'San Francisco', trip.origin.name
    assert_equal 'Devoto', trip.destination.name
    assert_equal Date.parse('26/02/2017'), trip.departure_date
    assert_equal Date.parse('26/02/2017'), trip.arrival_date
    assert_equal 1, trip.shipment_publications.count
    assert_equal shipment_publications(:one), trip.shipment_publications.first
    
    assert_redirected_to carriers_url
    
  end

  test 'mark as driving' do
    # Asserts before call
    trip_before_mark_as_driving = trips(:one)
    
    assert_not_equal Trip::STATUS_DRIVING, trip_before_mark_as_driving.status
  
    # Mark as driving
    xhr :patch, :mark_as_driving, id: trip_before_mark_as_driving.id
  
    # Asserts after call
    trip_after_mark_as_finished = Trip.find(trip_before_mark_as_driving.id)
  
    assert_equal Trip::STATUS_DRIVING, trip_after_mark_as_finished.status
  end

  test 'mark as finished' do
    trip_before_mark_as_finished = trips(:one)
    
    # Check that trip is not set as delivered
    assert_not_equal Trip::STATUS_FINISHED, trip_before_mark_as_finished.status
    
    # Call controller
    xhr :patch, :mark_as_finished, id: trip_before_mark_as_finished.id
    
    # Assert that Trip has new status
    trip_after_mark_as_finished = Trip.find(trip_before_mark_as_finished.id)
    
    assert_equal Trip::STATUS_FINISHED, trip_after_mark_as_finished.status
  end
  
  test 'try to deliver a trip that does not own us' do
    trip = trips(:two)
  
    # Call controller
    assert_raises UnauthorizedException do
      xhr :patch, :mark_as_finished, id: trip.id
    end
    
  end
end
