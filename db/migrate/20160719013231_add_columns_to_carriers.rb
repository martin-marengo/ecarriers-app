class AddColumnsToCarriers < ActiveRecord::Migration
  def change
    add_column :carriers, :business_name, :string
    add_column :carriers, :phone_number, :string
    add_column :carriers, :company_description, :string
  end
end
