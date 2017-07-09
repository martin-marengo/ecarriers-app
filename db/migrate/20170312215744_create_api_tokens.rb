class CreateApiTokens < ActiveRecord::Migration
  def up
    add_column :sellers, :api_token, :string, default: nil
  end
  
  def down
    remove_column :sellers, :api_token
  end
end
