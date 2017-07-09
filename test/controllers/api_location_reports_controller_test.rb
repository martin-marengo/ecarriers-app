require 'test_helper'

class ApiLocationReportsControllerTest < ActionController::TestCase
  def setup
    @trip = trips(:one)
  end
  
  test 'should report location' do
    assert_difference('LocationReport.count') do
      post :report, json
    end

    assert_response :success
    
    location_report = LocationReport.last

    assert_equal -31.430436, location_report.lat
    assert_equal 62.087392, location_report.lng
    assert_equal @trip, location_report.trip
  end
  
  private

  def json
    '
{
  "api_token": "' + @trip.carrier.api_token + '",
  "trip_id": ' + @trip.id.to_s + ',
  "lat": -31.430436,
  "lng": 62.087392
}
'
  end
end
