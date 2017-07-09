class Seller < ActiveRecord::Base
  include MailValidation

  has_many :messages, as: :person
  has_many :shipment_publications, as: :client
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable,
         :lockable, :timeoutable

  validate :uniqueness_of_email

  validates :business_name, :phone_number, :address, presence: true
  
  def name
    business_name
  end
  
  def full_name
    business_name
  end
  
  def has_api_token?
    !api_token.blank?
  end

  def same_as(seller)
    unless seller.blank? or id.blank? or seller.id.blank?
      return true if id == seller.id
    end
    return false
  end
end
