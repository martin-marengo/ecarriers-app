class ShipmentPublicationService
  def initialize
    @person_service = PersonService.new
  end
  
  # @param [ShipmentPublicationApiForm] shipment_publication_form
  def create!(shipment_publication_form)
    shipment_publication = shipment_publication_form.get_shipment_publication
    shipment_publication.status = ShipmentPublication::STATUS_EVALUATING_BIDS
    shipment_publication.client = @person_service.current_person
    
    shipment_publication.save
    
    return shipment_publication
  end
  
  # Mark shipment_publication as "being shipped"
  # @param [ShipmentPublication] shipment_publication
  def mark_as_being_shipped!(shipment_publication)
    @person_service.check_that_is_current_person shipment_publication.carrier

    shipment_publication.status = ShipmentPublication::STATUS_BEING_SHIPPED
    shipment_publication.save!
  end
  
  # Mark shipment_publication as delivered
  # @param [Object] shipment_publication
  def mark_as_delivered!(shipment_publication)
    @person_service.check_that_is_current_person shipment_publication.carrier
    
    shipment_publication.status = ShipmentPublication::STATUS_DELIVERED
    shipment_publication.save!

    ShipmentPublicationMailer.items_delivered(shipment_publication).deliver_later
  end
end