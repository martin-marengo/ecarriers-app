class CreateBids < ActiveRecord::Migration
  def up
    create_table :bids do |t|
      t.text :description, default: nil

      t.monetize :price

      t.references :carrier, index: true, foreign_key: true
      t.references :shipment_publication, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
  
  def down
    drop_table :bids
  end
end
