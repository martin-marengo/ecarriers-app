require 'test_helper'

class ShipmentPublicationControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  def setup
    @request.env['devise.mapping'] = Devise.mappings[:user]
    
    user = users(:cacho_castaña)
    
    sign_in user
  end
  
  test 'should get select parent category' do
    get :show, {id: :select_parent_category}
    
    assert_response 200
  end

  test 'should get select child category' do
    category = categories(:child_category_a)
    
    get :show, id: :select_child_category, category_id: category.id
  
    assert_response 200
  end

  test 'should get show publication info' do
    category = categories(:child_category_a)
  
    get :show, id: :publication_info, category_id: category.id
  
    assert_response 200
  end

  test 'should get addresses info' do
    category = categories(:child_category_a)
  
    post :update, {
      id: :addresses_info,
      articles_number: 1,
      shipment_publication: {
        title: 'Title',
        special_care: false,
        blanket_wrap: false,
      },
      item: {
        #Item 1
        0 => {
          name: 'Short description 1',
          length_m: 1,
          length_cm: 2,
          width_m: 3,
          width_cm: 4,
          height_m: 5,
          height_cm: 6,
          weight_kg: 7,
          quantity: 8,
        },
        #Item 2
        1 => {
          name: 'Short description 2',
          length_m: 8,
          length_cm: 7,
          width_m: 6,
          width_cm: 5,
          height_m: 4,
          height_cm: 3,
          weight_kg: 2,
          quantity: 1,
        },
      },
      category_id: category.id,
    }
  
    assert_response 200
  end

  test 'should get check info' do
    post :update, complete_publication_data(:check_info)
  
    assert_response 200
  end

  test 'should make a successful publication' do
    post :update, complete_publication_data(:successful_publication)
    
    # Assert that publication has been saved
    shipment_publication = ShipmentPublication.find_by(title: 'Test title')
    
    assert_not_nil shipment_publication
    
    assert_equal 'San Francisco', shipment_publication.pickup_address.city_name
    assert_equal 'Devoto', shipment_publication.delivery_address.city_name
    
    assert_equal Date.new(2016, 12, 9), shipment_publication.pickup_service_condition.date
    assert_equal Date.new(2016, 12, 23), shipment_publication.delivery_service_condition.date
    assert_equal ShipmentPublication::STATUS_EVALUATING_BIDS, shipment_publication.status
    
    assert_equal 2, shipment_publication.items.length
    
    assert_response 200
  end
  
  private
  
  def complete_publication_data(step)
    category = categories(:child_category_a)
    
    {
      id: step,
      articles_number: 1,
      pickup_service_condition: 'before_of',
      delivery_service_condition: 'after_of',
    
      shipment_publication: {
        title: 'Test title',
        special_care: false,
        blanket_wrap: false,
      
        pickup_address: {
          location_description: 'San Francisco, Córdoba, Argentina',
          city_name: 'San Francisco',
          region_name: 'Córdoba',
          country_name: 'Argentina',
          lat: '-31.42499919999999',
          lng: '-62.08415990000003',
          street_name: 'Jonas Salk',
          street_number: 1160,
          floor_number: 5,
          apartment: 'B'
        },
        delivery_address: {
          location_description: 'Devoto, Córdoba, Argentina',
          city_name: 'Devoto',
          region_name: 'Córdoba',
          country_name: 'Argentina',
          lat: '-31.4016153',
          lng: '-62.3061831',
          street_name: '25 de Mayo',
          street_number: 1268,
          floor_number: 2,
          apartment: 'A'
        },
        pickup_service_condition: {
          date: '09/12/2016',
          from_date: nil,
          to_date:nil,
          'from_time(1i)': 2016,
          'from_time(2i)': 12,
          'from_time(3i)': 9,
          'from_time(4i)': 20,
          'from_time(5i)': 00,
          'to_time(1i)': 2016,
          'to_time(2i)': 12,
          'to_time(3i)': 9,
          'to_time(4i)': 21,
          'to_time(5i)': 00,
        },
        delivery_service_condition: {
          date: '23/12/2016',
          from_date: nil,
          to_date:nil,
          'from_time(1i)': 2016,
          'from_time(2i)': 12,
          'from_time(3i)': 9,
          'from_time(4i)': 20,
          'from_time(5i)': 00,
          'to_time(1i)': 2016,
          'to_time(2i)': 12,
          'to_time(3i)': 9,
          'to_time(4i)': 21,
          'to_time(5i)': 00,
        }
      },
      item: {
        #Item 1
        0 => {
          name: 'Short description 1',
          length_m: 1,
          length_cm: 2,
          width_m: 3,
          width_cm: 4,
          height_m: 5,
          height_cm: 6,
          weight_kg: 7,
          quantity: 8,
        },
        #Item 2
        1 => {
          name: 'Short description 2',
          length_m: 8,
          length_cm: 7,
          width_m: 6,
          width_cm: 5,
          height_m: 4,
          height_cm: 3,
          weight_kg: 2,
          quantity: 1,
        },
      },
      category_id: category.id,
    }
  end
  
end
