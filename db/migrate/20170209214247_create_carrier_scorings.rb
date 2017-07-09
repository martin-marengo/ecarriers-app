class CreateCarrierScorings < ActiveRecord::Migration
  def change
    create_table :carrier_scorings do |t|
      t.references :shipment_publication, index: true, foreign_key: true
      t.integer :service_quality
      t.integer :delivery_time
      t.text :feedback
      t.boolean :recommended

      t.timestamps null: false
    end
  end
end
