class AddParentCategoryToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :parent_category_id, :integer, index: true
    add_foreign_key :categories, :categories, column: :parent_category_id
  end
end
