require 'test_helper'

class ApiTripsControllerTest < ActionController::TestCase
  
  def setup
    @trip = trips(:one)
  end
  
  test 'should mark as driving' do
    assert_not_equal Trip::STATUS_DRIVING, @trip.status
    
    patch :mark_as_driving, json
    
    assert_response :success
    
    trip_after_call = Trip.find @trip.id
    assert_equal Trip::STATUS_DRIVING, trip_after_call.status
  end

  test 'should mark as finished' do
    assert_not_equal Trip::STATUS_FINISHED, @trip.status
  
    patch :mark_as_finished, json
  
    assert_response :success
  
    trip_after_call = Trip.find @trip.id
    assert_equal Trip::STATUS_FINISHED, trip_after_call.status
  end

  test 'should get trip' do
    get :trip, {
      id: @trip.id, 
      api_token: carriers(:one).api_token
    }
    
    expected_response = {
      id: @trip.id,
      origin: 'San Francisco, Córdoba, Argentina',
      destination: 'Devoto, Córdoba, Argentina',
      status: Trip::STATUS_HAVE_TO_FETCH_ITEMS,
      departure_date: '2017-01-01',
      shipment_publications:[
        {
          id: @trip.shipment_publications.first.id, 
          client: 'Cacho Castaña',
          description: 'One',
          pickup_address: 'Jonas Salk 1160, San Francisco, Córdoba, Argentina',
          delivery_address: 'Buenos Aires 3561, Número de piso: 5, Departamento: 5, Devoto, Córdoba, Argentina',
          items: [
            {
              description: 'Valid complete',
              quantity: 2
            }
          ],
          status: ShipmentPublication::STATUS_WAITING_PICKUP
        }
      ]
    }
  
    assert_response :success
    
    assert_equal expected_response, JSON.parse(@response.body).deep_symbolize_keys!
  end

  test 'should get non finished trips' do
    get :non_finished, {
      api_token: carriers(:one).api_token
    }
  
    expected_response = {
      trips: [
        id: @trip.id,
        origin: 'San Francisco, Córdoba, Argentina',
        destination: 'Devoto, Córdoba, Argentina',
        status: Trip::STATUS_HAVE_TO_FETCH_ITEMS,
        departure_date: '2017-01-01',
        shipment_publications:[
          {
            id: @trip.shipment_publications.first.id,
            client: 'Cacho Castaña',
            description: 'One',
            pickup_address: 'Jonas Salk 1160, San Francisco, Córdoba, Argentina',
            delivery_address: 'Buenos Aires 3561, Número de piso: 5, Departamento: 5, Devoto, Córdoba, Argentina',
            items: [
              {
                description: 'Valid complete',
                quantity: 2
              }
            ],
            status: ShipmentPublication::STATUS_WAITING_PICKUP
          }
        ]
      ]
    }
  
    assert_response :success
  
    assert_equal expected_response, JSON.parse(@response.body).deep_symbolize_keys!
  end
  
  private
  
  def json
    '
{
  "api_token": "api_token_one",
  "id": ' + @trip.id.to_s + '
}
'
  end

end
