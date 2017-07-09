###### Country
country_a = Country.new(name: 'Argentina', code: 'AR')
country_a.save!

##### Region
# Dejar Cordoba sin acento ya que así aparece en Google Maps (si están diferentes no funciona la búsqueda)
region_a = Region.new(name: 'Cordoba', country: country_a)
region_a.save!

##### Cities
city_a = City.new(name: 'San Francisco', region: region_a, country: country_a)
city_a.save!
city_b = City.new(name: 'Córdoba', region: region_a, country: country_a)
city_b.save!
city_c = City.new(name: 'Devoto', region: region_a, country: country_a)
city_c.save!
city_d = City.new(name: 'Cruz del Eje', region: region_a, country: country_a)
city_d.save!

###### Addresses
address_a = Address.new(street_name: 'Calle 1', street_number: '123',
                        city: city_a, location_description: 'San Francisco, Cordoba, Argentina',
                        lat: -31.428373, lng: -62.084668)
address_a.save!

address_b = Address.new(street_name: 'Calle 2', street_number: '456',
                        city: city_b, location_description: 'Córdoba, Cordoba, Argentina',
                        lat: -31.413839, lng: -64.196540)
address_b.save!

address_c = Address.new(street_name: 'Calle 3', street_number: '789',
                        city: city_c, location_description: 'Devoto, Cordoba, Argentina',
                        lat: -31.404938, lng: -62.305091)
address_c.save!

address_d = Address.new(street_name: 'Calle 4', street_number: '1011',
                        city: city_d, location_description: 'Cruz del Eje, Cordoba, Argentina',
                        lat: -30.724103, lng: -64.800065)
address_d.save

##### Users, Sellers and Carriers
user_a = User.new(
    name: 'Martín',
    last_name: 'Marengo',
    password: 'qweasdzxc',
    email: 'marengo.martin@gmail.com',
)
user_a.skip_confirmation!
user_a.save!

user_b = User.new(
    name: 'Agustín',
    last_name: 'Ruatta',
    password: 'qweasdzxc',
    email: 'agustinruatta@gmail.com',
)
user_b.skip_confirmation!
user_b.save!

user_c = User.new(
    name: 'Carlos',
    last_name: 'Villagran',
    password: 'qweasdzxc',
    email: 'carlos.villagran@test.com',
)
user_c.skip_confirmation!
user_c.save!

user_d = User.new(
    name: 'Ivanna',
    last_name: 'Montalvo',
    password: 'qweasdzxc',
    email: 'ivanna.montalvo@test.com',
)
user_d.skip_confirmation!
user_d.save!

user_e = User.new(
    name: 'Catalina',
    last_name: 'Pella',
    password: 'qweasdzxc',
    email: 'catalina.pella@test.com',
)
user_e.skip_confirmation!
user_e.save!

user_f = User.new(
    name: 'Pablo',
    last_name: 'Pascual',
    password: 'qweasdzxc',
    email: 'pablo.pascual@test.com',
)
user_f.skip_confirmation!
user_f.save!

user_g = User.new(
    name: 'Nadia',
    last_name: 'Rodríguez',
    password: 'qweasdzxc',
    email: 'nadia.rodriguez@test.com',
)
user_g.skip_confirmation!
user_g.save!

user_h = User.new(
    name: 'Orlando',
    last_name: 'Terranova',
    password: 'qweasdzxc',
    email: 'orlando.terranova@test.com',
)
user_h.skip_confirmation!
user_h.save!

user_i = User.new(
    name: 'Florencia',
    last_name: 'Labat',
    password: 'qweasdzxc',
    email: 'florencia.labat@test.com',
)
user_i.skip_confirmation!
user_i.save!

user_j = User.new(
    name: 'Federico',
    last_name: 'Mellera',
    password: 'qweasdzxc',
    email: 'federico.mellera@test.com',
)
user_j.skip_confirmation!
user_j.save!

seller_a = Seller.new(
    business_name: 'Empresa Online A',
    phone_number: '3564123456789',
    address: address_a,
    password: 'qweasdzxc',
    email: 'ecarriers.contact@gmail.com',
)
seller_a.skip_confirmation!
seller_a.save!

carrier_a = Carrier.new(
    business_name: 'Transportista A',
    phone_number: '3564123456789',
    password: 'qweasdzxc',
    email: 'scruby.contact@gmail.com',
    company_description: 'Description',
    profile_picture: File.new("#{Rails.root}/test/helper_files/some_image.png"),
    address: address_b,
)
carrier_a.skip_confirmation!
carrier_a.save!

###### Service conditions
after_condition_a = AfterCondition.new(date: Time.local(2016, 9, 26, 23, 59))
after_condition_a.save!
before_condition_a = BeforeCondition.new(date: Time.local(2016, 11, 10, 23, 59))
before_condition_a.save!
on_condition_a = OnCondition.new(date: Time.local(2016, 12, 5, 10, 15))
on_condition_a.save!
between_condition_a = BetweenCondition.new(from_date: Time.local(2016, 12, 15, 10, 15), to_date: Time.local(2017, 1, 5, 10, 15))
between_condition_a.save!

###### Shipment publications
appliances = Category.find_by_code_name 'appliances'
outdoor_equipment = Category.find_by_code_name 'outdoor_equipment'
pianos = Category.find_by_code_name 'pianos'
furniture = Category.find_by_code_name 'furniture'

### Web User's Shipment publications
# 0 - 24
25.times { |i|
  shipment_publication = ShipmentPublication.new(
      title: "Publicación de envío #{i}",
      client: user_a,
      pickup_address: address_a,
      delivery_address: address_b,
      pickup_service_condition: before_condition_a,
      delivery_service_condition: on_condition_a,
      category: appliances,
      status: ShipmentPublication::STATUS_EVALUATING_BIDS,
  )
  shipment_publication.save!

  item = Item.new(
      length_m: 0,
      length_cm: 70,
      width_m: 0,
      width_cm: 40,
      height_m: 0,
      height_cm: 18,
      weight_kg: 32,
      quantity: 1,
      name: "Detalles item publicación #{i}",
      shipment_publication: shipment_publication
  )
  item.save!
}

# 25 - 49
25.times { |i|
  shipment_publication = ShipmentPublication.new(
      title: "Publicación de envío #{25 + i}",
      client: user_a,
      pickup_address: address_b,
      delivery_address: address_a,
      pickup_service_condition: after_condition_a,
      delivery_service_condition: before_condition_a,
      category: outdoor_equipment,
      status: ShipmentPublication::STATUS_EVALUATING_BIDS,
  )
  shipment_publication.save!

  item = Item.new(
      length_m: 0,
      length_cm: 70,
      width_m: 0,
      width_cm: 40,
      height_m: 0,
      height_cm: 18,
      weight_kg: 32,
      quantity: 1,
      name: "Detalles item publicación #{25 + i}",
      shipment_publication: shipment_publication,
  )
  item.save!
}

# 50 - 74
25.times { |i|
  shipment_publication = ShipmentPublication.new(
      title: "Publicación de envío #{50 + i}",
      client: user_a,
      pickup_address: address_c,
      delivery_address: address_d,
      pickup_service_condition: after_condition_a,
      delivery_service_condition: on_condition_a,
      category: pianos,
      status: ShipmentPublication::STATUS_EVALUATING_BIDS,
  )
  shipment_publication.save!

  item = Item.new(
      length_m: 0,
      length_cm: 70,
      width_m: 0,
      width_cm: 40,
      height_m: 0,
      height_cm: 18,
      weight_kg: 32,
      quantity: 1,
      name: "Detalles item publicación #{50 + i}",
      shipment_publication: shipment_publication,
  )
  item.save!
}

# 75 - 99
25.times { |i|
  shipment_publication = ShipmentPublication.new(
      title: "Publicación de envío #{75 + i}",
      client: user_a,
      pickup_address: address_d,
      delivery_address: address_c,
      pickup_service_condition: on_condition_a,
      delivery_service_condition: between_condition_a,
      category: furniture,
      status: ShipmentPublication::STATUS_EVALUATING_BIDS,
  )
  shipment_publication.save!

  item = Item.new(
      length_m: 0,
      length_cm: 70,
      width_m: 0,
      width_cm: 40,
      height_m: 0,
      height_cm: 18,
      weight_kg: 32,
      quantity: 1,
      name: "Detalles item publicación #{75 + i}",
      shipment_publication: shipment_publication
  )
  item.save!
}


### Seller's Shipment publications
25.times { |i|
  shipment_publication = ShipmentPublication.new(
    title: "Publicación de envío #{i}",
    client: seller_a,
    pickup_address: address_a,
    delivery_address: address_b,
    pickup_service_condition: before_condition_a,
    delivery_service_condition: on_condition_a,
    category: appliances,
    status: ShipmentPublication::STATUS_EVALUATING_BIDS,
  )
  shipment_publication.save!

  item = Item.new(
    length_m: 0,
    length_cm: 70,
    width_m: 0,
    width_cm: 40,
    height_m: 0,
    height_cm: 18,
    weight_kg: 32,
    quantity: 1,
    name: "Detalles item publicación #{i}",
    shipment_publication: shipment_publication
  )
  item.save!
}

####### Web user's Bids
# Create one bid for each of last 25 publications.
result = ShipmentPublication.where(client: user_a).last(25)
result.each_with_index do |shipment_publication, i|
  bid = Bid.new(
      price_cents: ((i + 1)*15.80) * 100,
      description: "Detalle de oferta #{i.to_s}",
      shipment_publication: shipment_publication,
      carrier: carrier_a
  )
  bid.save!
end

# Create 30 bids for last publication (all from the same carrier, it's not correct but it's just for testing).
sp = ShipmentPublication.where(client: user_a).last!
30.times do |i|
  if i < 6
    bid = Bid.new(
        price_cents: ((i + 1)*15.80) * 100,
        description: 'Nam sed bibendum sem. Fusce malesuada, nibh non facilisis ultrices, nulla tellus consectetur
lorem, ac venenatis nulla eros dictum metus. Mauris risus eros, consequat nec interdum eu, lacinia sit amet purus.
Etiam et mollis purus. Curabitur aliquet mauris risus, non fermentum erat tincidunt in. Sed eget felis vitae nisl
aliquam rhoncus ac nec sem. Maecenas magna magna, egestas sed condimentum nec, interdum faucibus purus.
Ut vestibulum, elit a blandit volutpat.',
        shipment_publication: sp,
        carrier: carrier_a
    )
    bid.save!
  else
    bid = Bid.new(
        price_cents: ((i + 1)*15.80) * 100,
        description: "Detalle de oferta #{i.to_s}",
        shipment_publication: sp,
        carrier: carrier_a
    )
    bid.save!
  end
end

# User trip publications
20.times do
  user_trip_publication = UserTripPublication.new(
      user: user_b,
      departure_date: Date.new(2017, 8, 10),
      departure_time: Time.new(2017, 8, 10, 12, 0),
      arrival_date: Date.new(2017, 8, 10),
      arrival_time: Time.new(2017, 8, 10, 18, 30),
      vehicle_description: 'Morbi et enim porta, porttitor risus id, eleifend lacus. Mauris quis enim vitae justo molestie molestie sit amet et arcu.',
      origin_location_description: 'San Francisco, Cordoba, Argentina',
      origin_city: city_a,
      destination_location_description: 'Cruz del Eje, Cordoba, Argentina',
      destination_city: city_d,
      origin_lat: -31.428373,
      origin_lng: -62.084668,
      destination_lat: -30.724103,
      destination_lng: -64.800065)
  user_trip_publication.save!
end

20.times do
  user_trip_publication = UserTripPublication.new(
      user: user_b,
      departure_date: Date.new(2017, 8, 10),
      departure_time: Time.new(2017, 8, 10, 12, 0),
      arrival_date: Date.new(2017, 8, 10),
      arrival_time: Time.new(2017, 8, 10, 18, 30),
      vehicle_description: 'Fusce volutpat sapien non aliquet dictum. Praesent pharetra justo eu vulputate pharetra.',
      origin_location_description: 'San Francisco, Cordoba, Argentina',
      origin_city: city_a,
      destination_location_description: 'Cruz del Eje, Cordoba, Argentina',
      destination_city: city_d,
      origin_lat: -31.428373,
      origin_lng: -62.084668,
      destination_lat: -30.724103,
      destination_lng: -64.800065)
  user_trip_publication.save!
end

20.times do
  user_trip_publication = UserTripPublication.new(
      user: user_c,
      departure_date: Date.new(2017, 2, 28),
      departure_time: Time.new(2017, 2, 28, 12, 0),
      arrival_date: Date.new(2017, 3, 1),
      arrival_time: Time.new(2017, 3, 1, 8, 0),
      vehicle_description: 'Algo.',
      origin_location_description: 'Devoto, Cordoba, Argentina',
      origin_city: city_c,
      destination_location_description: 'Córdoba, Cordoba, Argentina',
      destination_city: city_b,
      origin_lat: -31.404938,
      origin_lng: -62.305091,
      destination_lat: -31.413839,
      destination_lng: -64.196540)
  user_trip_publication.save!
end

# Create several shipment request for a user trip publication
user_trip = UserTripPublication.order(:created_at).last

shipment_request_b = ShipmentRequest.new(
    user: user_b,
    user_trip_publication: user_trip,
    items_description: 'Nulla vel laoreet orci, a fringilla neque. Nullam cursus finibus leo, a venenatis lorem lacinia in.')
shipment_request_b.save!

shipment_request_d = ShipmentRequest.new(
    user: user_d,
    user_trip_publication: user_trip,
    items_description: 'Nullam cursus finibus leo, a venenatis lorem lacinia in.')
shipment_request_d.save!

shipment_request_e = ShipmentRequest.new(
    user: user_e,
    user_trip_publication: user_trip,
    items_description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis eros nisi, nec tristique ipsum facilisis ut.')
shipment_request_e.save!

shipment_request_f = ShipmentRequest.new(
    user: user_f,
    user_trip_publication: user_trip,
    items_description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi facilisis eros nisi, nec tristique ipsum facilisis ut.')
shipment_request_f.save!

shipment_request_g = ShipmentRequest.new(
    user: user_g,
    user_trip_publication: user_trip,
    items_description: 'Lorem ipsum dolor sit amet.')
shipment_request_g.save!

shipment_request_h = ShipmentRequest.new(
    user: user_h,
    user_trip_publication: user_trip,
    items_description: 'Maecenas congue egestas neque, a feugiat dolor varius id. Pellentesque euismod eleifend magna.')
shipment_request_h.save!

shipment_request_i = ShipmentRequest.new(
    user: user_i,
    user_trip_publication: user_trip,
    items_description: 'Donec fringilla elit dolor, sit amet faucibus purus ultrices nec.')
shipment_request_i.save!

shipment_request_j = ShipmentRequest.new(
    user: user_j,
    user_trip_publication: user_trip,
    items_description: 'Aliquam congue ante vel lacus placerat, vitae vulputate lacus vestibulum.')
shipment_request_j.save!