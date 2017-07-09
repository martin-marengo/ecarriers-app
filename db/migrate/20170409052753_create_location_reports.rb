class CreateLocationReports < ActiveRecord::Migration
  def up
    create_table :location_reports do |t|
      t.references :trip, index: true, foreign_key: true
      t.float :lat
      t.float :lng

      t.timestamps null: false
    end
  end
  
  def down
    drop_table :location_reports
  end
end
