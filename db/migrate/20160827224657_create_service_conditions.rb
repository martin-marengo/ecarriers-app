class CreateServiceConditions < ActiveRecord::Migration
  def change
    create_table :service_conditions do |t|
      t.time :from_time
      t.time :to_time
      t.date :date, default: nil
      t.date :from_date, default: nil
      t.date :to_date, default: nil
      t.string :type

      t.timestamps null: false
    end
  end
end
