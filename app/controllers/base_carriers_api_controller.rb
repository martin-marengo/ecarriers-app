class BaseCarriersApiController < BaseApiController
  before_filter :authenticate_carrier_from_token!, :set_current_carrier_in_person_service, except: :login
  
  private
  
  def authenticate_carrier_from_token!
    # When a GET method is used, we can not use JSON. Instead, we use GET params
    if request.get?
      api_token = params[:api_token]
    else
      api_token = @json[:api_token]
    end
    
    if api_token.blank?
      raise UnauthorizedException.new('API Token not present in request')
    else
      @carrier = nil
      
      Carrier.find_each do |carrier|
        if Devise.secure_compare(carrier.api_token, api_token)
          @carrier = carrier
          # DO NOT BREAK THE LOOP! This prevent that an attacker can establish API token validity based on response time.
        end
      end
      
      raise UnauthorizedException.new('API Token is not valid') if @carrier.nil?
    end
  end
  
  # We have to save in this way, because is the only to get it in object services
  def set_current_carrier_in_person_service
    PersonService.current_person = @carrier
  end
end