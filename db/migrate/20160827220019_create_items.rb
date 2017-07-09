class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :name, null: false, default: ''
      t.integer :length_m
      t.integer :length_cm
      t.integer :width_m
      t.integer :width_cm
      t.integer :height_m
      t.integer :height_cm
      t.float :weight_kg
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
