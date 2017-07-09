class BudgetsMailer < ApplicationMailer
  default from: 'ecarriers.contact@gmail.com'

  def created(shipment_request)
    setup_email shipment_request

    @user_trip_publication_url = user_trip_publication_url shipment_request.user_trip_publication

    mail to: shipment_request.user.email, subject: "eCarriers - El usuario #{@traveler_name} ha presupuestado tu envío."
  end

  def updated(shipment_request)
    setup_email shipment_request

    @user_trip_publication_url = user_trip_publication_url shipment_request.user_trip_publication

    mail to: shipment_request.user.email, subject: "eCarriers - El usuario #{@traveler_name} modificó el presupuesto para tu envío."
  end

  def canceled(shipment_request)
    setup_email shipment_request

    @user_trip_publication_url = user_trip_publication_url shipment_request.user_trip_publication

    mail to: shipment_request.user.email, subject: "eCarriers - El usuario #{@traveler_name} canceló el presupuesto para tu envío."
  end

  def accepted(shipment_request)
    setup_email shipment_request

    @user_trip_publication_url = show_own_user_trip_publication_url shipment_request.user_trip_publication

    mail to: shipment_request.user_trip_publication.user.email, subject: "eCarriers - El usuario #{@client_name} aceptó tu presupuesto."
  end

  private

  def setup_email(shipment_request)
    @client_name = shipment_request.user.full_name

    @traveler_name = shipment_request.user_trip_publication.user.full_name

    @user_trip_publication_title = shipment_request.user_trip_publication.title
  end

end
