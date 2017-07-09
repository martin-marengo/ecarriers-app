class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  force_ssl if: :ssl_configured?
  
  before_filter :set_current_person_in_person_service

  before_filter :ensure_signup_complete

  helper_method :any_signed_in?

  def any_signed_in?
    (user_signed_in? or carrier_signed_in? or seller_signed_in?)? true : false
  end

  def after_sign_in_path_for(resource)
    if resource.instance_of? Carrier
      carriers_path
    elsif resource.instance_of? User
      root_path
    elsif resource.instance_of? Seller
      root_path
    end
  end
  
  # Authenticate if an user or seller is logged in
  def authenticate_client!
    # Is importan the order, because we want to redirect to user login page. So, in the else must be the `authenticate_user!`
    if current_seller
      authenticate_seller!
    else
      authenticate_user!
    end
  end
  
  # Authenticate if an user, seller or carrier is logged in
  def authenticate_person!
    if current_carrier
      authenticate_carrier!
    elsif current_user
      authenticate_user!
    else
      authenticate_seller!
    end
  end
  
  # Get current User or Client
  # @return [User|Client]
  def current_client
    if current_user
      current_user
    elsif current_seller
      current_seller
    else
      nil
    end
  end

  # Get current User, Client or Carrier
  # @return [User|Client|Carrier]
  def current_person
    if current_user
      current_user
    elsif current_carrier
      current_carrier
    elsif current_seller
      current_seller
    else
      nil
    end
  end

  # @param [String] url URL where user will be redirected. If is null, he will be redirected to root url.
  # status: 401 were removed because of this:
  # http://stackoverflow.com/questions/4310913/ruby-on-rails-how-to-get-rid-of-you-are-being-redirected-page
  def redirect_unauthorized(url = nil)
    begin
      if url.nil?
        redirect_to root_url
      else
        redirect_to url
      end
    rescue ActionController::RedirectBackError
      redirect_to root_url
    end
  end
  
  private
  
  # We have to save in this way, because is the only to get it in object services
  def set_current_person_in_person_service
    PersonService.current_person = current_person
  end

  def ensure_signup_complete
    # Ensure we don't go into an infinite loop
    return if action_name == 'finish_omniauth_signup' or action_name == 'update_omniauth_user'
    
    # Redirect to the 'finish_signup' page if the user
    # email hasn't been verified yet
    if current_user&.has_to_complete_data
      redirect_to finish_omniauth_signup_url(current_user)
    end
  end

  # Force page to reload on browser back
  def set_cache_headers
    response.headers['Cache-Control'] = 'no-cache, no-store, max-age=0, must-revalidate'
    response.headers['Pragma'] = 'no-cache'
    response.headers['Expires'] = 'Fri, 01 Jan 1990 00:00:00 GMT'
  end

  def ssl_configured?
    Rails.env.production?
  end
end
