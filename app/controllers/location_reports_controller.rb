class LocationReportsController < ApplicationController
  before_action :authenticate_person!
  
  def initialize
    super()
    
    @person_service = PersonService.new
  end
  
  # GET /location_reports/1
  def show
    @shipment_publication = ShipmentPublication.find(params[:id])
    
    @person_service.check_that_is_current_person @shipment_publication.client
    
    trip = @shipment_publication.trip
    
    raise NotFoundException if trip.blank?
    
    @location_report = trip.location_reports.last
  end
end
