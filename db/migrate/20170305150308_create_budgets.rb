class CreateBudgets < ActiveRecord::Migration
  def change
    create_table :budgets do |t|
      t.monetize :price
      t.belongs_to :shipment_request, index: true, foreign_key: true
      t.boolean :accepted, default: false

      t.timestamps null: false
    end
  end
end
