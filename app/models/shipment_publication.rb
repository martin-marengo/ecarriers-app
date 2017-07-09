class ShipmentPublication < ActiveRecord::Base
  belongs_to :pickup_address, class_name: 'Address', dependent: :destroy, autosave: true
  belongs_to :delivery_address, class_name: 'Address', dependent: :destroy, autosave: true
  belongs_to :pickup_service_condition, class_name: 'ServiceCondition', dependent: :destroy, autosave: true
  belongs_to :delivery_service_condition, class_name: 'ServiceCondition', dependent: :destroy, autosave: true
  
  belongs_to :accepted_bid, class_name: 'Bid'
  belongs_to :client, polymorphic: true
  belongs_to :carrier
  belongs_to :category
  belongs_to :trip
  
  has_one :carrier_scoring, dependent: :destroy

  has_many :items, dependent: :destroy
  has_many :bids, dependent: :destroy
  
  validates :title, :client, :category, :pickup_address, :delivery_address, :pickup_service_condition,
            :delivery_service_condition, presence: true
  
  STATUS_EVALUATING_BIDS = 'evaluating_bids'
  STATUS_WAITING_PICKUP = 'waiting_pickup'
  STATUS_BEING_SHIPPED = 'being_shipped'
  STATUS_DELIVERED = 'delivered'

  # before_destroy :destroy_accepted_bid

  validates_inclusion_of :status, in: [
    STATUS_EVALUATING_BIDS, STATUS_WAITING_PICKUP, STATUS_BEING_SHIPPED, STATUS_DELIVERED
  ]
  
  ## SCOPES
  
  scope :trip_finished, -> {
    joins(:trip).where(trips: {status: Trip::STATUS_FINISHED})
  }

  scope :trip_with_have_to_fetch_items, -> {
    joins(:trip).where(trips: {status: Trip::STATUS_HAVE_TO_FETCH_ITEMS})
  }
  
  scope :accepted_bid_of_carrier, -> (carrier) {
    joins(:accepted_bid).merge(Bid.with_carrier(carrier))
  }
  
  scope :ready_to_ship, -> (current_carrier) {
    accepted_bid_of_carrier(current_carrier).where(status: ShipmentPublication::STATUS_WAITING_PICKUP)
  }

  scope :ready_to_ship_without_trip_assigned, -> (current_carrier) {
    accepted_bid_of_carrier(current_carrier)
        .where(status: ShipmentPublication::STATUS_WAITING_PICKUP, trip: nil)
  }
  
  scope :carrier_has_delivered_it, -> (current_carrier) {
    accepted_bid_of_carrier(current_carrier).where(status: ShipmentPublication::STATUS_DELIVERED)
  }

  scope :categories, -> (categories_ids) { where category_id: categories_ids }

  scope :origin, -> (city, region, country) { joins(pickup_address: {city: { region: :country }}).
    where(cities: { name: city }, regions: { name: region }, countries: { name: country }) }

  scope :destination, -> (city, region, country) { joins(delivery_address: {city: { region: :country }}).
      where(cities: { name: city }, regions: { name: region }, countries: { name: country }) }

  scope :origin_destination, -> (or_city, or_region, or_country, dest_city, dest_region, dest_country) {
    joins(pickup_address: {city: { region: :country }}, delivery_address: {city: { region: :country }}).
      where(cities: { name: or_city }, regions: { name: or_region }, countries: { name: or_country },
            cities_addresses: { name: dest_city }, regions_cities: { name: dest_region},
            countries_regions: { name: dest_country } )}

  scope :origin_description, -> (description) { joins(:pickup_address).
      where('lower(addresses.location_description) like ?', "%#{description.downcase}%" )}

  scope :destination_description, -> (description) { joins(:delivery_address).
      where('lower(addresses.location_description) like ?', "%#{description.downcase}%" )}

  scope :location_descriptions, -> (or_description, dest_description) { joins(:pickup_address, :delivery_address).
    where(
          'lower(addresses.location_description) LIKE ? AND lower(delivery_addresses_shipment_publications.location_description) LIKE ?',
          "%#{or_description.downcase}%",
          "%#{dest_description.downcase}%")}

  ## GETTERS

  def title_text
    title.presence || ''
  end

  def category_name
    category.try(:name)
  end

  def full_category_name
    full_name = ''
    
    if category.try(:parent_category).try(:name)
      full_name = category.parent_category.name + ': '
    end
    
    full_name += category_name
    
    return full_name
  end

  # Cat code name otherwise default
  def category_codename
    category.try(:code_name) || 'complete_cargo'
  end

  # City name otherwise nil
  def origin_part_1
    city_name(pickup_address)
  end

  # Region and/or country names, otherwise nil
  def origin_part_2
    region_country_names(pickup_address)
  end

  # Location description, otherwise lat&lng, otherwise empty
  def origin_part_3
    pickup_address.try(:location_description) || coordinates_text(pickup_address) || ''
  end

  # City name otherwise nil
  def destination_part_1
    city_name(delivery_address)
  end

  # Region and/or country names, otherwise nil
  def destination_part_2
    region_country_names(delivery_address)
  end

  # Location description, otherwise lat&lng, otherwise empty
  def destination_part_3
    pickup_address.try(:location_description) || coordinates_text(pickup_address) || ''
  end

  # @return [float, float]
  def origin_coordinates
    pickup_address.try(:lat) and pickup_address.try(:lng) ? [pickup_address.lat, pickup_address.lng] : nil
  end

  # @return [float, float]
  def delivery_coordinates
    delivery_address.try(:lat) and delivery_address.try(:lng) ? [delivery_address.lat, delivery_address.lng] : nil
  end

  # GETTERS COORDENADAS INDIVIDUALES
  def origin_lat
    pickup_address.try(:lat) ? pickup_address.lat : ''
  end

  def origin_lng
    pickup_address.try(:lng) ? pickup_address.lng : ''
  end

  def destination_lat
    delivery_address.try(:lat) ? delivery_address.lat : ''
  end

  def destination_lng
    delivery_address.try(:lng) ? delivery_address.lng : ''
  end

  def origin_location_text
    pickup_address.try(:location_description) ? pickup_address.location_description : ''
  end

  def destination_location_text
    delivery_address.try(:location_description) ? delivery_address.location_description : ''
  end

  def publication_date
    I18n.localize(created_at, format: '%d de %B de %Y, %H:%M hs').capitalize
  end

  def client_email
    client ? client.email : ''
  end

  def pickup_address_text
    if pickup_address
      pickup_address.address_text
    else
      return ''
    end
  end

  def delivery_address_text
    if delivery_address
      delivery_address.address_text
    else
      return ''
    end
  end
  
  def has_an_accepted_bid?
    !accepted_bid.nil?
  end
  
  # If user can score carrier
  # @return [Boolean]
  def can_score_carrier
    !trip.nil? and
      trip.items_were_delivered and
      carrier_scoring.nil?
  end

  def was_delivered?
    status == STATUS_DELIVERED
  end

  private

  def city_name(address)
    address.try(:city).try(:name)
  end

  # Region and/or country name or nil
  def region_country_names(address)
    region_country = ''
    
    # Set region if exists
    region_country = address.city.region.name if address.try(:city).try(:region).try(:name)
    
    if country_name(address)

      if region_country.empty?
        # Only county
        region_country = country_name(address)
      else
        # Region and country
        region_country += " (#{country_name(address)})"
      end
    end

    region_country.empty? ? nil : region_country
  end

  def country_name(address)
    address.try(:city).try(:country).try(:name) || address.try(:city).try(:region).try(:country).try(:name)
  end

  # Lat and lng
  def coordinates_text(address)
    address.try(:lat) and address.try(:lng) ? "#{address.lat.to_s}, #{address.lng.to_s}" : nil
  end

  def destroy_accepted_bid
    # bid_id = self.accepted_bid.id
    # self.update_attribute(:accepted_bid, nil)
    # Bid.find(bid_id).delete
    # bids.delete_all
  end

end

# Foreign keys with custom names:
# Sia answer in http://stackoverflow.com/questions/27809342/rails-migration-add-reference-to-table-but-different-column-name-for-foreign-ke
# http://sevenseacat.net/2015/02/24/add_foreign_key_gotchas.html