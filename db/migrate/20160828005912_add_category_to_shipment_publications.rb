class AddCategoryToShipmentPublications < ActiveRecord::Migration
  def change
    add_reference :shipment_publications, :category, index: true, foreign_key: true
  end
end
