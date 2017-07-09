class BidsMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'

  def created(bid, client)
    @client_name = client.name
    @shipment_publication_title = bid.shipment_publication.title
    @carrier_name = bid.carrier.business_name
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: bid.shipment_publication.id

    mail to: client.email, subject: 'eCarriers - ¡Recibiste una oferta para tu publicación!'
  end

  def updated(bid, client)
    @client_name = client.name
    @shipment_publication_title = bid.shipment_publication.title
    @carrier_name = bid.carrier.business_name
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: bid.shipment_publication.id

    mail to: client.email, subject: "eCarriers - El transportista #{bid.carrier.business_name} ha modificado su oferta"
  end

  def canceled(bid, client)
    @client_name = client.name
    @shipment_publication_title = bid.shipment_publication.title
    @carrier_name = bid.carrier.business_name
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: bid.shipment_publication.id

    mail to: client.email, subject: "eCarriers - El transportista #{bid.carrier.business_name} ha cancelado su oferta"
  end

  # @param [Bid] bid
  def accepted(bid)
    shipment_publication = bid.shipment_publication
    
    @carrier_name = bid.carrier.business_name
    @shipment_publication_title = shipment_publication.title
    @client_name = shipment_publication.client.full_name
    
    @shipment_publication_url = carrier_url(id: shipment_publication.id)

    mail to: bid.carrier.email, subject: 'eCarriers - ¡Tu oferta ha sido aceptada!'
  end
end
