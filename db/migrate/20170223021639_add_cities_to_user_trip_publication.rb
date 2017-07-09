class AddCitiesToUserTripPublication < ActiveRecord::Migration
  def change
    add_column :user_trip_publications, :origin_city_id, :integer, index: true
    add_foreign_key :user_trip_publications, :cities, column: :origin_city_id

    add_column :user_trip_publications, :destination_city_id, :integer, index: true
    add_foreign_key :user_trip_publications, :cities, column: :destination_city_id
  end
end
