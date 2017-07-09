class Users::RegistrationsController < Devise::RegistrationsController
  before_action :set_user, only: [:update_omniauth_user, :finish_omniauth_signup]
  before_action :authenticate_user!, only: [:finish_omniauth_signup, :update_omniauth_user]
  
  # GET /users/:id/finish_omniauth_signup
  def finish_omniauth_signup
    
  end

  # PATCH /users/:id/finish_omniauth_signup
  def update_omniauth_user
    if @user.update(update_omniauth_user_params)
      bypass_sign_in(@user)
      
      redirect_to shipment_publications_url, 
                  notice: 'Su perfil fue actualizado correctamente. Ingrese a su mail para confirmar el email'
    else
      @show_errors = true
      
      render 'finish_omniauth_signup'
    end
  end

  protected

  def after_inactive_sign_up_path_for(resource)
    if resource.instance_of? User
      new_user_session_path
    end
  end

  private
  
  def sign_up_params
    params.require(:user).permit(:name, :last_name, :email, :password, :password_confirmation)
  end

  def account_update_params
    params.require(:user).permit(:name, :last_name, :email, :password, :password_confirmation, :current_password)
  end
  
  def update_omniauth_user_params
    params.require(:user).permit(:email, :last_name)
  end

  private
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    accessible = [ :name, :email ] # extend with your own params
    accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
    params.require(:user).permit(accessible)
  end

end