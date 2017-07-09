class Bid < ActiveRecord::Base
  belongs_to :carrier
  belongs_to :shipment_publication

  has_one :conversation, as: :topic, dependent: :destroy
  
  scope :with_carrier, -> (carrier) {
    where(carrier: carrier)
  }

  # Price config. More info: https://github.com/RubyMoney/money-rails#usage
  monetize :price_cents

  validates :description, :price_cents, :carrier, :shipment_publication, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }, allow_blank: true
  
  validate :can_do_a_bid
  
  def can_do_a_bid
    if shipment_publication&.has_an_accepted_bid?
      errors[:shipment_publication] = 'Esta publicación ya tiene una oferta aceptada'
    end
  end
end
