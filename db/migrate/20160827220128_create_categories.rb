class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.text :description, default: ''
      t.boolean :are_measures_required, default: true
      t.boolean :is_weight_required, default: true

      t.timestamps null: false
    end
  end
end
