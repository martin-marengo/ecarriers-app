class City < ActiveRecord::Base
  belongs_to :region
  belongs_to :country
  has_many :addresses
  has_many :user_trip_publications, foreign_key: :origin_city_id
  has_many :user_trip_publications, foreign_key: :destination_city_id

  validates :name, :country, presence: true
  validates :name, uniqueness: { scope: :region, case_sensitive: false }
  
  def region_name
    region.blank? ? '' : region.name
  end
  
  def country_name
    region&.country.blank? ? '' : region.country.name
  end
  
  # Return the full place name, including
  # - City name
  # - Region name, if exists
  # - Country name
  def full_place_name
    name = name() + ', '
    
    unless region&.name.blank?
      name += region.name + ', '
    end
    
    name += country.name
    
    name
  end
end
