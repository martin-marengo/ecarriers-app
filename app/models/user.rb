class User < ActiveRecord::Base
  include MailValidation
  
  DEFAULT_LAST_NAME = '¡Cámbiame!'
  TEMP_EMAIL_PREFIX = 'change@me'

  # No se pone dependent destroy por si se borra accidentalmente el user.
  has_many :shipment_publications, as: :client
  has_many :user_trip_publications

  has_many :messages, as: :person

  has_many :shipment_requests

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :lockable, :timeoutable, :omniauthable

  validate :uniqueness_of_email

  validates :name, :last_name, presence: true
  
  def self.default_user
    return User.new
  end
  
  def full_name
    name + ' ' + last_name
  end

  def same_as(user)
    unless user.blank? or id.blank? or user.id.blank?
      return true if id == user.id
    end
    return false
  end

  def self.find_for_oauth(auth, signed_in_resource = nil)
    # Get the identity and user if they exist
    identity = Identity.find_or_create_for_oauth(auth)
  
    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user
    
    # Create the user if needed
    if user.nil?
      user = new_auth_user auth
    end
    
    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    
    user
  end

  def has_to_complete_data
    has_default_email or has_default_last_name
  end
  
  def has_default_email
    self.email&.start_with?(TEMP_EMAIL_PREFIX) and 
      #If unconfirmed email is not blank, it means that a email confirmation is sent, and we are waiting.
      unconfirmed_email.blank?
  end
  
  def has_default_last_name
    last_name == DEFAULT_LAST_NAME
  end
  
  private
  # @return [User]
  def self.new_auth_user(auth)
    # Get the existing user by email if the provider gives us a verified email.
    # If no verified email was provided we assign a temporary email and ask the
    # user to verify it on the next step.
    # If we assign the email without verify with (auth.info.verified || auth.info.verified_email), somebody can
    # do an account in Facebook with an existent eCarriers user's email, and get possession of his account.
    email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
    email = auth.info.email if email_is_verified
    user = User.where(email: email).first if email
    
    # Create the user if it's a new registration
    if user.nil?
      # Split name between spaces. The last is the last name. For example, if we have that `auth.extra.raw_info.name` is
      # "First Second Third", "First Second" is the name, and "Third" is the last name.
      # If `auth.extra.raw_info.name` is just one word, set a default last name
      sent_name = auth.extra.raw_info.name
      
      split_words = sent_name.split
      
      if split_words.count > 1
        last_name = split_words.pop
        first_name = split_words.join ' '
      else
        first_name = split_words.first
        last_name = DEFAULT_LAST_NAME
      end
      
      user = User.new(
        name: first_name,
        last_name: last_name,
        email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
        password: Devise.friendly_token[0,20]
      )
      user.skip_confirmation!
      
      user.save!
    end
    
    return user
  end
end
