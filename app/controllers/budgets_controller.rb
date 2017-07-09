class BudgetsController < ApplicationController
  before_action :authenticate_user!, :set_current_user
  before_action :set_shipment_request
  before_action :validate_trip_ownership, except: [:accept]
  before_action :set_budget, only: [:edit, :update, :destroy, :accept]
  before_action :validate_shipment_request_ownership, only: [:accept]

  # Traveler action
  def new
    @budget = @shipment_request.build_budget

    respond_to do |format|
      format.js
    end
  end

  # Traveler action
  def create
    @budget = @shipment_request.build_budget(budget_params)

    if @budget.save
      BudgetsMailer.created(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  # Traveler action
  def edit
    respond_to do |format|
      format.js
    end
  end

  # Traveler action
  def update
    if @budget.update(budget_params)
      BudgetsMailer.updated(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  # Traveler action
  def destroy
    @budget.destroy

    if @budget.destroyed?
      BudgetsMailer.canceled(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  # Client (sender) action
  def accept
    @budget.accepted = true

    if @budget.save
      BudgetsMailer.accepted(@shipment_request).deliver_later
    end

    respond_to do |format|
      format.js
    end
  end

  private

  def set_current_user
    @current_user = current_user
  end

  def set_budget
    @budget = Budget.find(params[:id])
  end

  def set_shipment_request
    @shipment_request = ShipmentRequest.find(params[:shipment_request_id])
  end

  def validate_trip_ownership
    if !@shipment_request or !@shipment_request.user_trip_publication.user.same_as(@current_user)
      redirect_unauthorized user_trip_publications_url
    end
  end

  def budget_params
    budget_parameters = params.require(:budget).permit(:id, :price, :shipment_request_id)

    # Transform to float, because Budget.money does not support a string value
    budget_parameters[:price] = budget_parameters[:price].to_f

    return budget_parameters
  end

  def validate_shipment_request_ownership
    if !@shipment_request or !@shipment_request.user.same_as(@current_user)
      redirect_unauthorized user_trip_publications_url
    end
  end
end