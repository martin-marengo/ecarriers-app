class CreateUserTripPublications < ActiveRecord::Migration
  def change
    create_table :user_trip_publications do |t|
      t.belongs_to :user, index: true, foreign_key: true
      t.date :departure_date, default: nil
      t.time :departure_time
      t.date :arrival_date, default: nil
      t.time :arrival_time
      t.string :vehicle_description
      t.string :origin_location_description
      t.string :destination_location_description
      t.boolean :canceled, default: false
      t.float :origin_lat, default: nil
      t.float :origin_lng, default: nil
      t.float :destination_lat, default: nil
      t.float :destination_lng, default: nil

      t.timestamps null: false
    end
  end
end
