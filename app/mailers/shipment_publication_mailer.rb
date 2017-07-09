class ShipmentPublicationMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'
  
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.shipment_publication_mailer.published.subject
  #
  def published(shipment_publication, user)
    @user_name = user.name
    
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: shipment_publication.id

    mail to: user.email, subject: 'eCarriers - ¡Envío publicado!'
  end
  
  # @param [ShipmentPublication] shipment_publication
  def items_delivered(shipment_publication)
    @client_name = shipment_publication.client.name
    @carrier_name = shipment_publication.carrier.business_name
    @shipment_publication_title = shipment_publication.title
    @address = shipment_publication.delivery_address.address_text_with_location
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: shipment_publication.id

    mail to: shipment_publication.client.email, subject: 'eCarriers - ¡Envío publicado!'
  end
end
