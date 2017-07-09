class AddAcceptedBidToShipmentPublication < ActiveRecord::Migration
  def up
    add_column :shipment_publications, :accepted_bid_id, :integer, index: true
    add_foreign_key :shipment_publications, :bids, column: :accepted_bid_id
  end
  
  def down
    remove_column :shipment_publications, :accepted_bid_id
  end
end
