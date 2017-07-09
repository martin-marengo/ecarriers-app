class ApiTripsController < BaseCarriersApiController
  
  def initialize
    @trip_service = TripService.new
    @person_service = PersonService.new
  end
  
  api :PATCH, 'trips/mark_as_driving/', 'Establecer un viaje en estado "Viajando"'
  description 'Establece el estado del viaje en "Viajando". Usado cuando se comienza un viaje.'
  
  param :api_token, String, required:true, desc: 'API Token'
  param :id, Integer, required: true, desc: 'ID del viaje'
  
  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "id": 5
}

La respuesta es un código HTTP.
EXAMPLE
  def mark_as_driving
    trip = Trip.find(@json[:id])
    
    @trip_service.mark_as_driving! trip
    
    render json: {}
  end
  
  
  
  api :PATCH, 'trips/mark_as_finished/', 'Establecer un viaje en estado "Finalizado"'
  description 'Establece el estado del viaje en "Finalizado". Usado cuando se termina un viaje.'
  
  param :api_token, String, required:true, desc: 'API Token'
  param :id, Integer, required: true, desc: 'ID del viaje'
  
  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "id": 5
}

La respuesta es un código HTTP.
  EXAMPLE
  def mark_as_finished
    trip = Trip.find(@json[:id])
  
    @trip_service.mark_as_finished! trip

    render json: {}
  end
  
  
  
  api :GET, 'trips/{:id}?api_token={:api_token}', 'Devuelve información sobre el viaje'
  description 'Devuelve información sobre el viaje'
  
  example <<-EXAMPLE 
Ejemplo de llamada:
https://www.ecarriers.com.ar/api/v1/trips/2?api_token=gSh3IJB6gzckoi6DEfHtiw

Ejemplo de respuesta:

{
  "id": 12,
	"origin": "San Francisco, Córdoba, Argentina",
	"destination": "La Plata, Buenos Aires, Argentina",
	"status": "driving",
  "departure_date": "2017-04-15",
	"shipment_publications": [
    {
      "id": 23,
      "client": "Jose Giménez",
      "description": "Transporte de muebles",
      "pickup_address": "Jonas Salk 1160, San Francisco, Córdoba, Argentina",
      "delivery_address": "Buenos Aires 567, La Plata, Buenos Aires, Argentina",
      "items": [
        {
          "description": "Placard",
          "quantity": 2
        },
        {
          "description": "Repisa",
          "quantity": 1
        },
      ],
      delivered: true
    },
    {
      "id": 26,
      "client": "Juan Perez",
      "description": "Transporte de televisor",
      "pickup_address": "Larrea 785",
      "delivery_address": "Salta 2634",
      "items": [
        {
          "description": "Smart TV",
          "quantity": 1
        },
      ],
      delivered: false
    }
  ]
}
  EXAMPLE
  def trip
    trip = Trip.find params[:id]
    
    @person_service.check_that_is_current_person trip.carrier
    
    render json: trip_json(trip)
  end
  
  
  
  api :GET, 'trips/non_finished?api_token={:api_token}', 'Devuelve todos los viajes NO FINALIZADOS del transportista'
  description 'Devuelve todos los viajes NO FINALIZADOS del transportista'
  
  example <<-EXAMPLE
Ejemplo de llamada:
https://www.ecarriers.com.ar/api/v1/trips/non_finished?api_token=gSh3IJB6gzckoi6DEfHtiw

Ejemplo de respuesta:
{
  trips: [
    {
      "id": 12,
      "origin": "San Francisco, Córdoba, Argentina",
      "destination": "La Plata, Buenos Aires, Argentina",
      "status": "driving",
      "departure_date": "2017-04-15",
      "shipment_publications": [
        {
          "id": 23,
          "client": "Jose Giménez",
          "description": "Transporte de muebles",
          "pickup_address": "Jonas Salk 1160, San Francisco, Córdoba, Argentina",
          "delivery_address": "Buenos Aires 567, La Plata, Buenos Aires, Argentina",
          "status":"delivered",
          "items": [
            {
              "description": "Placard",
              "quantity": 2
            },
            {
              "description": "Repisa",
              "quantity": 1
            },
          ]
        },
        {
          "id": 26,
          "client": "Juan Perez",
          "description": "Transporte de televisor",
          "pickup_address": "Larrea 785, San Francisco, Córdoba, Argentina",
          "delivery_address": "Salta 2634, La Plata, Buenos Aires, Argentina",
          "status":"waiting_pickup",
          "items": [
            {
              "description": "Smart TV",
              "quantity": 1
            },
          ]
        }
      ]
    },
    {
      "id": 18,
      "origin": "San Francisco, Córdoba, Argentina",
      "destination": "Mar del Plata, Buenos Aires, Argentina",
      "status": "have_to_pick_up_items",
      "departure_date": "2017-04-15",
      "shipment_publications": [
        {
          "id": 26,
          "client": "Juan Pérez",
          "description": "Transporte de heladera",
          "pickup_address": "Jujuy 673, San Francisco, Córdoba, Argentina",
          "delivery_address": "Buenos Aires 7326, Mar del Plata, Buenos Aires, Argentina",
          "status":"waiting_pickup",
          "items": [
            {
              "description": "Heladera Whirlpool",
              "quantity": 1
            },
          ]
        }
      ]
    }
  ]
}
  EXAMPLE
  def non_finished
    trips = []

    Trip.not_finished(@carrier).each do |trip|
      trips << trip_json(trip)
    end
  
    render json: {trips: trips}
  end
  
  private
  # @param [Trip] trip
  def trip_json(trip)
    
    trip = {
      id: trip.id,
      origin: trip.origin.full_place_name,
      destination: trip.destination.full_place_name,
      status: trip.status,
      departure_date: trip.departure_date.strftime('%Y-%m-%d'),
      shipment_publications: shipment_publications_json(trip)
    }
    
    return trip
  end
  
  def shipment_publications_json(trip)
    shipment_publications = []
  
    trip.shipment_publications.each do |shipment_publication|
      shipment_publications << {
        id: shipment_publication.id,
        client: shipment_publication.client.full_name,
        description: shipment_publication.title,
        pickup_address: shipment_publication.pickup_address.address_text_with_location,
        delivery_address: shipment_publication.delivery_address.address_text_with_location,
        status: shipment_publication.status,
        items: items_json(shipment_publication)
      }
    end
    
    return shipment_publications
  end

  # @param [ShipmentPublication] shipment_publication
  def items_json(shipment_publication)
    items = []
    
    shipment_publication.items.each do |item|
      items << {
        description: item.name,
        quantity: item.quantity,
      }
    end
    
    return items
  end
end
