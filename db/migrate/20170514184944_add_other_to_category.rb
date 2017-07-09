class AddOtherToCategory < ActiveRecord::Migration
  def up
    other = Category.new(name: 'Otro', description: 'Otro tipo de artículo', code_name: 'other')
    other.save!
  end
  
  def down
    other = Category.find_by_code_name 'other'
    other.delete
  end
end
