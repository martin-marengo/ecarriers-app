class AddSomeAttributesToTrip < ActiveRecord::Migration
  def up
    add_column :trips, :origin_id, :integer, index: true
    add_foreign_key :trips, :cities, column: :origin_id
  
    add_column :trips, :destination_id, :integer, index: true
    add_foreign_key :trips, :cities, column: :destination_id

    add_column :trips, :departure_date, :date
    add_column :trips, :arrival_date, :date
    
    add_reference :trips, :carrier, index: true
  end
  
  def down
    remove_column :trips, :origin_id
    remove_column :trips, :destination_id, :integer, index: true
    remove_column :trips, :departure_date
    remove_column :trips, :arrival_date
    remove_column :trips, :carrier_id
  end
end
