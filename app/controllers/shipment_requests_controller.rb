class ShipmentRequestsController < ApplicationController
  before_action :authenticate_user!, :set_current_user
  before_action :set_shipment_request, only: [:update, :destroy]
  before_action :validate_ownership, only: [:update, :destroy]

  def initialize(
      setup_shipment_request_service = SetupShipmentRequestService.new
  )
    super()

    @setup_shipment_request_service = setup_shipment_request_service
  end

  def create
    @shipment_request = ShipmentRequest.new(shipment_request_params)
    @shipment_request.user = @current_user

    if @shipment_request.save
      ShipmentRequestsMailer.created(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  def update
    if @shipment_request.update(shipment_request_params)
      ShipmentRequestsMailer.updated(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  def destroy
    user_trip_publication = @shipment_request.user_trip_publication

    @shipment_request.destroy

    if @shipment_request.destroyed?
      ShipmentRequestsMailer.canceled(@shipment_request).deliver_later
    end

    @shipment_request = @setup_shipment_request_service.call user_trip_publication.id, @current_user

    respond_to do |format|
      format.js
    end
  end

  private

  def set_shipment_request
    @shipment_request = get_shipment_request(params[:id])
  end

  def get_shipment_request(id)
    ShipmentRequest.find(id)
  end

  def shipment_request_params
    params.require(:shipment_request).permit(:id, :items_description, :user_trip_publication_id)
  end

  def set_current_user
    @current_user = current_user
  end

  def validate_ownership
    redirect_unauthorized user_trip_publications_url unless @shipment_request.user.same_as @current_user
  end
end