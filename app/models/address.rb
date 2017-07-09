class Address < ActiveRecord::Base
  has_one :shipment_publication, foreign_key: :pickup_address_id
  has_one :shipment_publication, foreign_key: :delivery_address_id
  has_one :carrier
  belongs_to :city

  validates :street_name, :street_number, :city, presence: true

  def region=(region)
    city.region = region
  end

  def country=(country)
    city.country = country
  end

  def city_name
    city ? city.name : ''
  end

  def region_name
    (city and city.region) ? city.region.name : ''
  end

  def country_name
    (city and city.country) ? city.country.name : ''
  end

  def self.default_address
    return Address.new()
  end

  def address_text
    if street_name and street_number
      text = street_name + ' ' + street_number
      unless floor_number.blank?
        text += ', Número de piso: ' + floor_number
      end
      unless apartment.blank?
        text += ', Departamento: ' + apartment
      end
      return text
    else
      return ''
    end
  end
  
  def address_text_with_location
    address_text + ', ' + city.full_place_name
  end

end
