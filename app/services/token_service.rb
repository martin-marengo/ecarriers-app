class TokenService
  def assign_token(person)
    if person.has_api_token?
      return
    end
    
    person.api_token = get_random_token
    
    person.save!
  end
  
  def remove_token(seller)
    seller.api_token = nil
    seller.save!
  end
  
  private
  # Get random token
  # @return [String]
  def get_random_token
    SecureRandom.urlsafe_base64
  end
end