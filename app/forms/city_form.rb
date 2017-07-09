class CityForm < AbstractForm
  def region
    Region.new(
      name: @params[:region_name],
      country: country
    )
  end

  def country
    Country.new(
      name: @params[:country_name],
      code: @params[:country_code]
    )
  end
  
  def city
    City.new(
      name: @params[:name],
      region: region,
      country: country
    )
  end

  def has_a_region?
    !region.name.strip.empty?
  end
end