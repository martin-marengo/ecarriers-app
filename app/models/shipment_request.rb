class ShipmentRequest < ActiveRecord::Base
  belongs_to :user
  belongs_to :user_trip_publication
  has_one :budget, dependent: :destroy

  has_one :conversation, as: :topic, dependent: :destroy

  validates :user, :user_trip_publication, :items_description, presence: true
  validate :existing

  def existing
    existing_shipment_request = ShipmentRequest.find_by(user_trip_publication: user_trip_publication, user: user)
    
    if !existing_shipment_request.nil? and existing_shipment_request.id != id
      errors.add(:base, 'Ya has realizado un pedido de envío para este viaje.')
    end
  end
end
