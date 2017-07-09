class TripsMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'
  default template_path: 'mails'

  # @param [ShipmentPublication] shipment_publication
  def shipment_publication_being_shipped(shipment_publication)
    @client_name = shipment_publication.client.name
    @shipment_publication_title = shipment_publication.title
    @carrier_name = shipment_publication.accepted_bid.carrier.business_name
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: shipment_publication.id

    mail to: shipment_publication.client.email, subject: 'eCarriers - ¡Tu envío está en camino!'
  end
end
