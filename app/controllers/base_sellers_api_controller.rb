class BaseSellersApiController < BaseApiController
  before_filter :authenticate_seller_from_token!, :set_current_seller_in_person_service
  
  private
  
  def authenticate_seller_from_token!
    if !@json[:api_token]
      raise UnauthorizedException.new('API Token not present in JSON')
    else
      @seller = nil
      
      Seller.find_each do |seller|
        if Devise.secure_compare(seller.api_token, @json[:api_token])
          @seller = seller
          # DO NOT BREAK THE LOOP! This prevent that an attacker can establish API token validity based on response time.
        end
      end
      
      raise UnauthorizedException.new('API Token is not valid') if @seller.nil?
    end
  end

  # We have to save in this way, because is the only to get it in object services
  def set_current_seller_in_person_service
    PersonService.current_person = @seller
  end
end