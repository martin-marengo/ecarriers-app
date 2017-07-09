class AddShipmentPublicationToItems < ActiveRecord::Migration
  def change
    add_reference :items, :shipment_publication, index: true, foreign_key: true
  end
end
# rails g migration add_shipment_publication_to_items shipment_publication:belongs_to