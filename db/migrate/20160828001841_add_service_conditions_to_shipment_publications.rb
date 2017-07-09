class AddServiceConditionsToShipmentPublications < ActiveRecord::Migration
  def change
    add_column :shipment_publications, :pickup_service_condition_id, :integer, index: true
    add_foreign_key :shipment_publications, :service_conditions, column: :pickup_service_condition_id

    add_column :shipment_publications, :delivery_service_condition_id, :integer, index: true
    add_foreign_key :shipment_publications, :service_conditions, column: :delivery_service_condition_id
  end
end
