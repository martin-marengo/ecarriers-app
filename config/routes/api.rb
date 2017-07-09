scope '/api' do
  scope '/v1' do
    scope '/shipment_publication' do
      post '/' => 'api_shipment_publication#create'
      patch '/mark_as_being_shipped' => 'api_carriers#mark_as_being_shipped'
      patch '/mark_as_delivered' => 'api_carriers#mark_as_delivered'
    end
    
    scope '/trips' do
      get '/non_finished' => 'api_trips#non_finished'
      get '/:id' => 'api_trips#trip'
      patch '/mark_as_driving' => 'api_trips#mark_as_driving'
      patch '/mark_as_finished' => 'api_trips#mark_as_finished'
    end
    
    scope '/carriers' do
      post '/login' => 'api_carriers#login'
    end
    
    scope 'location_reports' do
      post '/report' => 'api_location_reports#report'
    end
  end
end