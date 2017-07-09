class SetupShipmentRequestService

  # Retrieve or create a shipment_request for a given UserTripPublication and owner User
  # @param [integer] user_trip_publication_id
  # @param [User] current_user
  # @return [ShipmentRequest] New or existent shipment request
  def call(user_trip_publication_id, current_user)
    shipment_request = ShipmentRequest
                            .includes(:budget, :user_trip_publication, :user)
                            .where(user: current_user, user_trip_publication_id: user_trip_publication_id).first
    unless shipment_request
      user_trip_publication = UserTripPublication.find(user_trip_publication_id)
      shipment_request = ShipmentRequest.new
      shipment_request.user = current_user
      shipment_request.user_trip_publication = user_trip_publication
    end

    return shipment_request
  end

end