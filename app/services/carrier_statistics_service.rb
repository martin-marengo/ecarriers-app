class CarrierStatisticsService
  def initialize
    @person_service = PersonService.new
  end
  
  # @return [DestinationStatistic[]]
  def most_requested_destinations(from_date = nil, to_date = nil)
    data = Address.
      select('cities.id, COUNT(cities.id) as count').
      joins('
      INNER JOIN shipment_publications ON shipment_publications.delivery_address_id = addresses.id
      INNER JOIN cities ON addresses.city_id = cities.id')
    
    data = data.where('shipment_publications.created_at >= ?', from_date) unless from_date.blank?
    data = data.where('shipment_publications.created_at <= ?', to_date) unless to_date.blank?
    
    data = data.group('cities.id').order('count DESC')
    
    destinations = []
    
    data.each do |destination|
      city_name = City.find(destination.id).name
      
      destinations << DestinationStatistic.new(city_name, destination.count)
    end
    
    return destinations
  end


  # @return [RevenuePerMonthList]
  def revenues
    shipment_publications = ShipmentPublication.carrier_has_delivered_it(@person_service.current_person)
    
    list = RevenuePerMonthList.new
    
    shipment_publications.each do |shipment_publication|
      amount = shipment_publication.accepted_bid.price.amount.to_f
      year = shipment_publication.accepted_bid.created_at.year
      month = shipment_publication.accepted_bid.created_at.month
      
      list.add_amount amount, year, month
    end
    
    return list
  end
end