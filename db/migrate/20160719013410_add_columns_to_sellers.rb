class AddColumnsToSellers < ActiveRecord::Migration
  def change
    add_column :sellers, :business_name, :string
    add_column :sellers, :phone_number, :string
    add_column :sellers, :address, :string
  end
end
