class AddStatusToShipmentPublication < ActiveRecord::Migration
  def up
    change_table :shipment_publications do |t|
      t.string :status
    end
  end
  
  def down
    remove_column :shipment_publications, :status
  end
end
