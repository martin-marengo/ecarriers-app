class AcceptedBidService
  
  def initialize(person_service = PersonService.new)
    @person_service = person_service
  end
  
  def accept_bid(bid)
    # Assign bid
    shipment_publication = bid.shipment_publication
    shipment_publication.accepted_bid = bid
    shipment_publication.carrier = bid.carrier
    shipment_publication.status = ShipmentPublication::STATUS_WAITING_PICKUP

    # Check that current user is the owner of sent shipment publication
    @person_service.check_that_is_current_person shipment_publication.client
    
    shipment_publication.save!

    # Send mail to notify carrier that his bid was accepted
    BidsMailer.accepted(bid).deliver_later
  end
end