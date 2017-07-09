class Budget < ActiveRecord::Base
  belongs_to :shipment_request

  # Price config. More info: https://github.com/RubyMoney/money-rails#usage
  monetize :price_cents

  validates :shipment_request, :price_cents, presence: true
  validates :price, numericality: { greater_than_or_equal_to: 1 }, allow_blank: true
  validates_inclusion_of :accepted, in: [true, false]

end
