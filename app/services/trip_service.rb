class TripService
  
  def initialize(person_service = PersonService.new)
    @person_service = person_service
  end
  
  # Create a trip, assign to shipment_publication.
  # @return [Trip] Trip
  def create_trip(create_trip_form)
    trip = Trip.new
    
    trip.status = Trip::STATUS_HAVE_TO_FETCH_ITEMS
    trip.origin = create_trip_form.origin
    trip.destination = create_trip_form.destination
    trip.departure_date = create_trip_form.departure_date
    trip.arrival_date = create_trip_form.arrival_date
    trip.carrier = @person_service.current_person
    
    trip.shipment_publications = create_trip_form.shipment_publications
    
    check_shipment_publications trip.shipment_publications
    
    trip
  end

  # Set trip as driving, and save it.
  # @param [Trip] trip
  def mark_as_driving!(trip)
    @person_service.check_that_is_current_person trip.carrier
    
    trip.status = Trip::STATUS_DRIVING
    trip.save!
    
    trip.shipment_publications.each do |shipment_publication|
      TripsMailer.shipment_publication_being_shipped(shipment_publication).deliver_later
    end
  end
  
  # Set trip as finished, and save it.
  # @param [Trip] trip
  def mark_as_finished!(trip)
    @person_service.check_that_is_current_person trip.carrier
    
    trip.status = Trip::STATUS_FINISHED
    trip.save!
  end
  
  def check_shipment_publications(shipment_publications)
    shipment_publications.each do |shipment_publication|
      if(
        shipment_publication&.accepted_bid&.carrier != @person_service.current_person or
        shipment_publication.status != ShipmentPublication::STATUS_WAITING_PICKUP
      )
        raise UnauthorizedException.new
      end
    end
  end
end