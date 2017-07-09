class ShipmentRequestsMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'

  def created(shipment_request)
    setup_email shipment_request

    mail to: shipment_request.user_trip_publication.user.email, subject: 'eCarriers - ¡Recibiste un pedido de envío para tu viaje!'
  end

  def updated(shipment_request)
    setup_email shipment_request

    mail to: shipment_request.user_trip_publication.user.email, subject: "eCarriers - El usuario #{@client_name} modificó su pedido de envío."
  end

  def canceled(shipment_request)
    setup_email shipment_request

    mail to: shipment_request.user_trip_publication.user.email, subject: "eCarriers - El usuario #{@client_name} canceló su pedido de envío."
  end

  private

  def setup_email(shipment_request)
    # Mail from
    @client_name = shipment_request.user.full_name
    # Mail to
    @traveler_name = shipment_request.user_trip_publication.user.full_name

    @user_trip_publication_title = shipment_request.user_trip_publication.title

    @user_trip_publication_url = show_own_user_trip_publication_url shipment_request.user_trip_publication
  end

end
