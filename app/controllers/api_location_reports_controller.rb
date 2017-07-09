class ApiLocationReportsController < BaseCarriersApiController
  
  def initialize
    super()
    
    @person_service = PersonService.new
  end
  
  api :POST, 'location_reports/report', 'Guardar un reporte de ubicación'
  description 'Guarda un reporte de ubicación, el cual será usado para informar al usuario'

  param :api_token, String, required: true, desc: 'API Token'
  param :trip_id, Integer, required: true, desc: 'ID del viaje al cual se reporta la ubicación'
  param :lat, Float, required: true, desc: 'Latitud'
  param :lng, Float, required: true, desc: 'Longitud'
  
  example <<-EXAMPLE 
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "trip_id": 56,
  "lat": -31.430436,
  "lng": -62.087392,
} 
EXAMPLE
  def report
    trip = Trip.find(@json[:trip_id])
    
    @person_service.check_that_is_current_person trip.carrier
    
    location_report = LocationReport.new(
      trip: trip,
      lat: @json[:lat],
      lng: @json[:lng]
    )
    
    location_report.save!

    render json: {}
  end
end
