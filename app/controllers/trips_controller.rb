class TripsController < ApplicationController
  before_action :authenticate_carrier!
  before_action :set_carrier
  before_action :set_trip, only: [:mark_as_driving, :mark_as_finished]
  
  layout 'carrier_dashboard_layout'
  
  ACTION_MARK_AS_DRIVING = 'mark_as_driving'
  ACTION_MARK_AS_FINISHED = 'mark_as_finished'
  
  def initialize(
    trip_service = TripService.new
  )
    super()
    
    @trip_service = trip_service
  end
  
  def new
    @trip = Trip.new
    @trip.origin = @trip.destination = City.new
    
    @shipment_publications = ShipmentPublication.ready_to_ship_without_trip_assigned current_carrier

    redirect_to carriers_url, alert: 'No tienes ninguna publicación pendiente' if @shipment_publications.empty?
  end
  
  def create
    @trip = @trip_service.create_trip(CreateTripForm.new(params))

    respond_to do |format|
      if @trip.save
        format.html { redirect_to carriers_url,
                                  notice: 'Se ha guardado el viaje' }
      else
        @show_errors = true
        @shipment_publications = ShipmentPublication.ready_to_ship_without_trip_assigned current_carrier
        
        format.html { render :new }
      end
    end
  end

  # GET /show_mark_as_driving
  def show_mark_as_driving
    @title = 'Viajes pendientes'
    @trips = Trip.ready_to_mark_as_driving current_carrier
    @action = ACTION_MARK_AS_DRIVING
    
    render 'trip_list'
  end

  # PATCH /mark_as_driving
  def mark_as_driving
    @trip_service.mark_as_driving! @trip
    
    respond_to do |format|
      format.js
    end
  end

  # GET /show_mark_as_finished
  def show_mark_as_finished
    @title = 'Viajes en curso'
    @trips = Trip.ready_to_mark_as_finished current_carrier
    @action = ACTION_MARK_AS_FINISHED
    
    render 'trip_list'
  end
  
  # PATCH /mark_as_finished
  def mark_as_finished
    @trip_service.mark_as_finished! @trip

    respond_to do |format|
      format.js
    end
  end
  
  def set_carrier
    @carrier = current_carrier
  end
  
  def set_trip
    @trip = Trip.find params[:id]
  
    # If there is not a trip, redirect
    if @trip.blank?
      redirect_to root_url
    end
  end
end
