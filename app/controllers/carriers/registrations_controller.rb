class Carriers::RegistrationsController < Devise::RegistrationsController
  layout :layout_by_action
  
  def initialize(
    setup_address_service = SetupAddressService.new
  )
    super()
    
    @setup_address_service = setup_address_service
  end
  
  def layout_by_action
    if action_name == 'edit'
      'carrier_dashboard_layout'
    else
      'application'
    end
  end

  def new
    resource = build_resource({})
    resource.build_address
    
    respond_with resource
  end
  
  # POST /resource
  def create
    location_data = LocationForm.new(address_params, location_params)
    address = @setup_address_service.call location_data
    
    carrier_params = sign_up_params
    carrier_params[:address_attributes][:city_id] = address.city_id
    carrier_params[:address_attributes][:lat] = address.lat
    carrier_params[:address_attributes][:lng] = address.lng
    
    build_resource(carrier_params)

    resource.save
    
    yield resource if block_given?
    
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # PUT /resource
  # We need to use a copy of the resource because we don't want to change
  # the current user in place.
  def update
    carrier_params = account_update_params
    
    unless location_params_empty?
      location_data = LocationForm.new(address_params, location_params)
      
      address = @setup_address_service.call(location_data)
      
      carrier_params[:address_attributes][:city_id] = address.city_id
      carrier_params[:address_attributes][:lat] = address.lat
      carrier_params[:address_attributes][:lng] = address.lng
    end

    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    
    updated_resource = update_resource(resource, carrier_params)
    
    yield resource if block_given?
    
    if updated_resource
      if is_flashing_format?
        flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ?
            :update_needs_confirmation : :updated
        set_flash_message :notice, flash_key
      end
      
      bypass_sign_in resource, scope: resource_name
      
      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    if resource.instance_of? Carrier
      new_carrier_session_path
    end
  end

  def after_update_path_for(resource)
    carriers_path
  end

  private
  
  def sign_up_params
    params.require(:carrier).permit(:business_name, :email, :phone_number, :company_description,
                                    :profile_picture, :password, :password_confirmation, address_attributes:
                                        [:street_name, :street_number, :floor_number, :apartment, :location_description, :lat, :lng])
  end

  def account_update_params
    params.require(:carrier).permit(:business_name, :email, :phone_number, :company_description,
                                    :profile_picture, :password, :password_confirmation, :current_password,
                                    :delete_profile_picture, address_attributes:
                                        [:street_name, :street_number, :floor_number, :apartment, :location_description,
                                         :lat, :lng, :id, :city_id])
  end

  def address_params
    params.require(:carrier).require(:address_attributes).permit(:street_name, :street_number, :floor_number,
                                                                 :apartment, :lat, :lng, :location_description)
  end
  
  def location_params
    params.require(:carrier).require(:address_attributes).permit(:city_name, :region_name, :country_name)
  end

  def location_params_empty?
    # lat y lng no se validan porque no es fundamental que esten (aunque normalmente si estan estos 3, lat y lng tambien)
    (!location_params[:city_name] or location_params[:city_name].empty?) and
        (!location_params[:region_name] or location_params[:region_name].empty?) and
        (!location_params[:country_name] or location_params[:country_name].empty?)
  end

end
