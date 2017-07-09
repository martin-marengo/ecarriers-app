class StoreLocationService

  # Save or retrieve a city with its region and country.
  # @param [LocationForm|CityForm] location_form
  # @return [City] saved_city
  def call(location_form)
    saved_country = Country.find_by(name: location_form.country.name)
    
    if saved_country.nil?
      saved_country = location_form.country
      saved_country.save! unless saved_country.name.blank?
    end
    
    if location_form.has_a_region?
      saved_region = Region.where(name: location_form.region.name).where(country: saved_country).first

      if saved_region.nil?
        saved_region = location_form.region
        saved_region.country = saved_country

        saved_region.save! unless saved_region.name.blank? or saved_region.country.try(:id).blank?
      end
    else
      saved_region = nil
    end
    
    saved_city = City.where(name: location_form.city.name).where(region: saved_region).where(country: saved_country).first
    if saved_city.nil?
      saved_city = location_form.city
      saved_city.region = saved_region
      saved_city.country = saved_country

      saved_city.save! unless saved_city.name.blank? or saved_city.country.try(:id).blank?
    end
    
    return saved_city
  end

end