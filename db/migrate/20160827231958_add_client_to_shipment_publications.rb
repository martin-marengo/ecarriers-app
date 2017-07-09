class AddClientToShipmentPublications < ActiveRecord::Migration
  def up
    change_table :shipment_publications do |t|
      t.references :client, polymorphic: true, index: true
    end
  end
  
  def down
    remove_column :shipment_publications, :client_id
    remove_column :shipment_publications, :client_type
  end
end
