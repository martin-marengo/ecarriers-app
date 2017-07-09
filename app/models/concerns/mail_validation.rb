module MailValidation
  extend ActiveSupport::Concern
  
  private

  def uniqueness_of_email
    email = email()
    
    user_with_same_mail = User.find_by(email: email)
    carrier_with_same_mail = Carrier.find_by(email: email)
    seller_with_same_mail = Seller.find_by(email: email)
    
    if user_with_same_mail && user_with_same_mail != self
      add_error 'usuario'
    elsif carrier_with_same_mail && carrier_with_same_mail != self
      add_error 'transportista'
    elsif seller_with_same_mail && seller_with_same_mail != self
      add_error 'vendedor'
    end
    
  end
  
  def add_error(who_use_the_mail)
    # Clean the error added by devise if the mail was used by another person with the same class
    errors[:email].clear
    # Add the error
    errors[:email] << 'ya fué usado por un ' + who_use_the_mail
  end

end