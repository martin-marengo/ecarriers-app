class AddCarrierToShipmentPublications < ActiveRecord::Migration
  def change
    add_reference :shipment_publications, :carrier, index: true, foreign_key: true
  end
end
# rails g migration add_carrier_to_shipment_publications carrier:belongs_to
