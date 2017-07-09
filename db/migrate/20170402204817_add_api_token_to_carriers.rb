class AddApiTokenToCarriers < ActiveRecord::Migration
  def up
    add_column :carriers, :api_token, :string, default: nil
  end
  
  def down
    remove_column :carriers, :api_token
  end
end
