class Sellers::RegistrationsController < Devise::RegistrationsController

  protected

  def after_inactive_sign_up_path_for(resource)
    if resource.instance_of? Seller
      new_seller_session_path
    end
  end

  private
  
  def sign_up_params
    params.require(:seller).permit(:business_name, :email, :phone_number, :address, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:seller).permit(:business_name, :email, :phone_number, :address, :password, :password_confirmation, :current_password)
  end

end