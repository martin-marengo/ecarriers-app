class CarrierStatisticsController < ApplicationController
  before_action :authenticate_carrier!
  before_action :set_carrier
  
  layout 'carrier_dashboard_layout'
  
  def initialize
    super()
    
    @carrier_statistics_service = CarrierStatisticsService.new
  end

  def most_requested_destinations
    begin
      @from_date = params[:from_date]
      from_date = Date.strptime(@from_date, '%d/%m/%Y')
    rescue ArgumentError, TypeError
      @from_date = ''
      from_date = nil
    end

    begin
      @to_date = params[:to_date]
      to_date = Date.strptime(@to_date, '%d/%m/%Y')
    rescue ArgumentError, TypeError
      @to_date = ''
      to_date = nil
    end
    
    @data = @carrier_statistics_service.most_requested_destinations(from_date, to_date)
  end
  
  def revenues
    @revenues = @carrier_statistics_service.revenues
  end
  
  private
  
  def set_carrier
    @carrier = current_carrier
  end
end
