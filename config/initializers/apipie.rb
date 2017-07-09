Apipie.configure do |config|
  config.app_name                = 'eCarriers'
  config.api_base_url            = '/api/v1/'
  config.doc_base_url            = '/apipie'
  
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/*.rb"
  
  # Do not validate
  config.validate = false
  
  config.app_info = 'API eCarriers - Documentación'
end