require 'test_helper'

class UserTripPublicationsControllerTest < ActionController::TestCase
  include Devise::Test::ControllerHelpers
  
  setup do
    @request.env['devise.mapping'] = Devise.mappings[:user]
  
    user = users(:cacho_castaña)
  
    sign_in user
    
    @user_trip_publication = user_trip_publications(:one)
  end
  
  test 'should get index' do
    get :index
    
    assert_response :success
    
    assert_not_nil assigns(:user_trip_publications)
  end

  test 'should get new' do
    get :new
    
    assert_response :success

    assert_not_nil assigns(:user_trip_publication)
  end
  
  test 'should create user_trip_publication' do
    assert_difference('UserTripPublication.count') do
      post :create, user_trip_publication: user_trip_data
    end
  end

  test 'should show user_trip_publication' do
    get :show, id: user_trip_publications(:two).id
    
    assert_response :success
  end

  test 'should show own user_trip_publication' do
    get :show_own, id: @user_trip_publication
  
    assert_response :success
  end

  test 'should get edit' do
    get :edit, id: @user_trip_publication
    
    assert_response :success
  end

  test 'should get my publications' do
    get :my_publications, page: 1
    
    assert_not_nil assigns(:user_trip_publications)
    
    assert_response :success
  end

  test 'should update user_trip_publication' do
    patch :update, id: @user_trip_publication.id, user_trip_publication: user_trip_data
    
    assert_redirected_to user_trip_publication_path(assigns(:user_trip_publication))
  end

  test 'should destroy user_trip_publication' do
    assert_difference('UserTripPublication.count', -1) do
      delete :destroy, id: @user_trip_publication
    end

    assert_redirected_to my_publications_user_trip_publications_path
  end

  test 'should set visible user_trip_publication' do
    post :set_visible, id: @user_trip_publication
  
    assert_redirected_to show_own_user_trip_publication_path(@user_trip_publication)
  end

  test 'should set not visible user_trip_publication' do
    post :set_not_visible, id: @user_trip_publication
  
    assert_redirected_to show_own_user_trip_publication_path(@user_trip_publication)
  end
  
  private 
  
  def user_trip_data
    return {
      vehicle_description: 'Vehicle description',
      departure_date: '01/01/2017',
      departure_time: '12:00',
      arrival_date: '02/01/2017',
      arrival_time: '13:00',
      origin_location_description: 'San Francisco, Córdoba, Argentina',
      origin_city_attributes: {
        city_name: 'San Francisco',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      },
      destination_city_attributes: {
        city_name: 'Devoto',
        region_name: 'Córdoba',
        country_name: 'Argentina',
      },
      destination_location_description: 'Devoto, Córdoba, Argentina',
      origin_lat: 50,
      origin_lng: 50,
      destination_lat: 50,
      destination_lng: 50,
    }
  end
end
