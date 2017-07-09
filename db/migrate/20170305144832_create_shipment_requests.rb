class CreateShipmentRequests < ActiveRecord::Migration
  def change
    create_table :shipment_requests do |t|
      t.text :items_description
      t.belongs_to :user, index: true, foreign_key: true
      t.belongs_to :user_trip_publication, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
