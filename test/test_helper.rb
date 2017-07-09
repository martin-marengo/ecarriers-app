# Coverage
require 'simplecov'

SimpleCov.start('rails') do
  add_filter '/test/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/vendor/'

  add_group 'Controllers', 'app/controllers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Views', 'app/views'

  add_filter do |source_file|
    source_file.lines.count < 5
  end
end
# End coverage

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Model helpers
  def correct_address
    address = Address.new(
      street_name: 'Juan de Garay',
      street_number: '1835',
      floor_number: '5',
      apartment: 'B',
      location_description: 'San Francisco, Córdoba, Argentina',
      city: correct_city,
      lat: 50,
      lng: 50
    )
  
    return address
  end

  def correct_city
    region = correct_region
    city = City.new(region: region, name: 'San Francisco')
  
    return city
  end

  def correct_region
    country = correct_country
    region = Region.new(country: country, name: 'Córdoba')
  
    return region
  end
  
  def correct_country
    return Country.new(name: 'Argentina')
  end
  
end
