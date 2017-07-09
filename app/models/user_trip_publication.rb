class UserTripPublication < ActiveRecord::Base
  belongs_to :user
  belongs_to :origin_city, class_name: 'City'
  belongs_to :destination_city, class_name: 'City'

  accepts_nested_attributes_for :origin_city
  accepts_nested_attributes_for :destination_city

  has_many :shipment_requests

  ARRIVAL_DATE_ERROR_MESSAGE = 'no puede ser anterior a la fecha de partida'
  ARRIVAL_TIME_ERROR_MESSAGE = 'debe ser posterior al horario de partida'

  validates :vehicle_description, :departure_date, :departure_time, :arrival_date, :arrival_time,
            :user, :origin_location_description, :destination_location_description, :origin_lat, :origin_lng,
            :destination_lat, :destination_lng, :origin_city, :destination_city, presence: true

  validate :valid_dates?, :valid_times?

  ## SCOPES PARA FILTRADO

  scope :origin, -> (city, region, country) { joins(origin_city: { region: :country }).
      where(cities: { name: city }, regions: { name: region }, countries: { name: country }) }

  scope :destination, -> (city, region, country) { joins(destination_city: { region: :country }).
      where(cities: { name: city }, regions: { name: region }, countries: { name: country }) }

  scope :origin_destination, -> (or_city, or_region, or_country, dest_city, dest_region, dest_country) {
    joins(origin_city: { region: :country }, destination_city: { region: :country }).
        where(cities: { name: or_city }, regions: { name: or_region }, countries: { name: or_country },
              cities_user_trip_publications: { name: dest_city }, regions_cities: { name: dest_region},
              countries_regions: { name: dest_country } )}

  scope :origin_description, -> (description) { where('lower(origin_location_description) like ?', "%#{description.downcase}%" )}

  scope :destination_description, -> (description) { where('lower(destination_location_description) like ?', "%#{description.downcase}%" )}

  scope :location_descriptions, -> (or_description, dest_description) { where(
          'lower(origin_location_description) LIKE ? AND lower(destination_location_description) LIKE ?',
          "%#{or_description.downcase}%",
          "%#{dest_description.downcase}%")}

  scope :departure_date, -> (departure_date) { where(departure_date: departure_date) }

  ## FIN SCOPES PARA FILTRADO

  ## GETTERS

  def title
    origin_city.name + ' - ' + destination_city.name
  end

  def user_name
    user ? user.full_name : ''
  end

  def user_email
    user ? user.email : ''
  end

  def departure_date_short
    departure_date.strftime('%d/%m/%Y')
  end

  def departure_date_time
    departure_date.strftime('%d/%m/%Y') + ' - ' + departure_time.strftime('%H:%M') + ' hs.'
  end

  def arrival_date_time
    arrival_date.strftime('%d/%m/%Y') + ' - ' + arrival_time.strftime('%H:%M') + ' hs.'
  end

  def publication_date
    I18n.localize(created_at, format: '%d de %B de %Y, %H:%M hs').capitalize
  end

  private

  def valid_dates?
    if departure_date && arrival_date
      errors[:arrival_date] << ARRIVAL_DATE_ERROR_MESSAGE if arrival_date < departure_date
    end
  end

  def valid_times?
    if (departure_date && arrival_date) && departure_date == arrival_date
      errors[:arrival_time] << ARRIVAL_TIME_ERROR_MESSAGE if arrival_time <= departure_time
    end
  end

end
