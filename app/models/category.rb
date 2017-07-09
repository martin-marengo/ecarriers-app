class Category < ActiveRecord::Base
  has_many :shipment_publications
  belongs_to :parent_category, class_name: 'Category' # si no anda, probar agregarle el foreign_key
  has_many :categories, foreign_key: :parent_category_id # si no anda, probar agregarle el class_name

  validates :name, :description, :code_name, presence: true
  validates_uniqueness_of :code_name
  
  def self.parent_categories
    Category.where(parent_category: nil)
  end
  
  def has_children
    categories.any?
  end
  
  def self.list_of_subcategories
    [
      # Boats and vehicles
      'car_and_light_trucks', 'motorcycles_and_mopeds', 'powerboats', 'personal_watercrafts', 'sailboats',
      'recreational_vehicles', 'atvs_and_power_sports', 'commercial_trucks', 'farm_equipment', 'construction_equipment',
      'trailer', 'another_vehicle',
      # Household
      'furniture', 'appliances', 'home_electronics', 'outdoor_equipment', 'sporting_equipment', 'antiques', 
      'art_and_glass', 'pianos', 'pool_tables',
      # Moves
      'small_studio', 'house', 'low_level_flat', 'upper_level_flat',
      # Freight subcategory
      'platform_with_new_articles', 'platform_with_old_articles', 'complete_cargo',
      # Animals subcategory
      'dogs', 'cats', 'horses', 'cattle', 'another_animal'
    ]
  end

end