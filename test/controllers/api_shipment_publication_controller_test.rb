require 'test_helper'

class ApiShipmentPublicationControllerTest < ActionController::TestCase
  
  test 'Create Shipment Publication' do
    assert_difference('ShipmentPublication.count') do
      post :create, json
    end
    
    assert_response :success
  end
  
  private
  
  def json
    <<-JSON 
{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "title": "Envío de muebles",
  "category": "furniture",
  "pickup_location": {
    "city_name": "San Francisco",
    "region_name": "Córdoba",
    "country_name": "Argentina",
    "country_code": "AR"
  },
  "pickup_address": {
    "street_name": "Jonas Salk",
    "street_number": 1160,
    "floor_number": 2,
    "apartment": "A",
    "lat": "-31.428373",
    "lng": "-62.084668"
  },
  "delivery_location": {
    "city_name": "Devoto",
    "region_name": "Córdoba",
    "country_name": "Argentina",
    "country_code": "AR"
  },
  "delivery_address": {
    "street_name": "25 de Mayo",
    "street_number": 236
  },
  "pickup_service_condition": {
    "type": "after_of",
    "date": "2017-01-01",
    "from_time": "15:50",
    "to_time": "17:35"
  },
  "delivery_service_condition": {
    "type": "between",
    "from_date": "2017-01-02",
    "to_date": "2017-01-03",
    "from_time": "12:30",
    "to_time": "16:00"
  },
  "items": [
    {
      "name": "Item A",
      "length_m": 1,
      "length_cm": 25,
      "width_m": 0,
      "width_cm": 30,
      "height_m": 2,
      "height_cm": 0,
      "weight_kg": 5,
      "quantity": 1
    },
    {
      "name": "Item B",
      "length_m": 0,
      "length_cm": 90,
      "width_m": 0,
      "width_cm": 50,
      "height_m": 2,
      "height_cm": 23,
      "weight_kg": 2,
      "quantity": 2
    }
  ]
}
    JSON
  end
  
end