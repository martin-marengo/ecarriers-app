class MessagesMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'

  def user_bid_comment(conversation, message)
    # The topic is a bid
    @shipment_publication = conversation.topic.shipment_publication
    @client = message.person
    @carrier = conversation.topic.carrier
    @bid_url = carrier_url(@shipment_publication)

    mail to: @carrier.email, subject: "eCarriers - El usuario \"#{@client.full_name}\" ha comentado tu oferta."
  end

  def carrier_bid_comment(conversation, message)
    # The topic is a bid
    @shipment_publication = conversation.topic.shipment_publication
    @carrier = message.person
    @client = conversation.topic.shipment_publication.client
    @shipment_publication_url = url_for controller: 'shipment_publications', action: :show, id: conversation.topic.shipment_publication.id

    mail to: @client.email, subject: "eCarriers - El transportista \"#{@carrier.business_name}\" ha comentado su oferta."
  end

  def shipment_request_owner_comment(conversation, message)
    # The topic is a shipment_request
    shipment_request = conversation.topic
    @owner_name = message.person.full_name
    traveler = shipment_request.user_trip_publication.user
    @traveler_name = traveler.full_name
    @user_trip_publication_url = show_own_user_trip_publication_url shipment_request.user_trip_publication
    @user_trip_publication_title = shipment_request.user_trip_publication.title

    mail to: traveler.email, subject: "eCarriers - El usuario \"#{@owner_name}\" ha comentado su pedido de envío."
  end

  def shipment_request_traveler_comment(conversation, message)
    # The topic is a shipment_request
    shipment_request = conversation.topic
    owner = shipment_request.user
    @owner_name = owner.full_name
    @traveler_name = message.person.full_name
    @user_trip_publication_url = user_trip_publication_url shipment_request.user_trip_publication
    @user_trip_publication_title = shipment_request.user_trip_publication.title

    mail to: owner.email, subject: "eCarriers - El usuario \"#{@traveler_name}\" ha comentado tu pedido de envío."
  end
end