class BaseApiController < ActionController::Base
  before_filter :parse_request

  force_ssl if: :ssl_configured?
  
  private
  
  def parse_request
    return [] if request.get?
    
    begin
      @json = JSON.parse(request.body.read)
      
      # In code, we use symbols instead of string. So, we need to symbolize all the keys
      @json.deep_symbolize_keys!
    rescue JSON::ParserError => e
      raise BadRequestException.new('The request is malformed')
    end
  end

  def ssl_configured?
    Rails.env.production?
  end
end