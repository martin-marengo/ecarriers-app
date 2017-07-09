class CreateTrips < ActiveRecord::Migration
  def up
    create_table :trips do |t|
      t.string :status
      
      t.timestamps null: false
    end
    
    add_reference :shipment_publications, :trip, index: true, foreign_key: true
  end
  
  def down
    drop_table :trips
    
    remove_column :shipment_publications, :trip
  end
end