class CreateAddresses < ActiveRecord::Migration
  def change
    create_table :addresses do |t|
      t.string :street_name
      t.string :street_number
      t.string :floor_number, default: nil
      t.string :apartment, default: nil
      t.string :location_description
      t.float :lat, default: nil
      t.float :lng, default: nil

      t.timestamps null: false
    end
  end
end
