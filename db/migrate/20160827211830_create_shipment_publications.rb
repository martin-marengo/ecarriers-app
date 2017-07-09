class CreateShipmentPublications < ActiveRecord::Migration
  def change
    create_table :shipment_publications do |t|
      t.string :title
      t.boolean :special_care, default: false
      t.boolean :blanket_wrap, default: false
      t.boolean :canceled, default: false

      t.timestamps null: false
    end
  end
end