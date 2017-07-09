class AddAddressesToShipmentPublications < ActiveRecord::Migration
  def change
    add_column :shipment_publications, :pickup_address_id, :integer, index: true
    add_foreign_key :shipment_publications, :addresses, column: :pickup_address_id

    add_column :shipment_publications, :delivery_address_id, :integer, index: true
    add_foreign_key :shipment_publications, :addresses, column: :delivery_address_id
  end
end