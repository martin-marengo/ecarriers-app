class AddCodeNameToCategory < ActiveRecord::Migration
  def change
    # add column es reversible, no hace falta hacer up y down
    add_column :categories, :code_name, :string
  end
end
