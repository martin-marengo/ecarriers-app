class AddAddressToCarriers < ActiveRecord::Migration
  def change
    add_reference :carriers, :address, index: true, foreign_key: true
  end
end
