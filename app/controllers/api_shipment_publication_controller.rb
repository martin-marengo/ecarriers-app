class ApiShipmentPublicationController < BaseSellersApiController
  
  def initialize
    super()
    
    @shipment_publication_service = ShipmentPublicationService.new
  end
  
  api :POST, 'shipment_publication/', 'Crear una nueva publicación de usuario'
  description 'Crea una nueva publicación de usuario, para que pueda ser ofertadas por los transportistas. Devuelve el id de la publicación de usuario creada'
  
  param :api_token, String, required:true, desc: 'API Token'
  param :title, String, required: true, desc: 'Título de la publicación'
  param :category, Category.list_of_subcategories, required: true, desc: 'Categoría de la publicación'
  param :special_care, :boolean, required: true, desc: 'Si se debe ser cuidadoso con los artículos'
  param :blanket_wrap, :boolean, required: true, desc: 'Si los artículos se transportan envuelto en mantas'
  
  param :pickup_location, Hash, required: true, desc: 'Información acerca del origen' do
    param :city_name, String, required: true, desc: 'Nombre de la ciudad de origen'
    param :region_name, String, required: true, desc: 'Nombre de la región de origen'
    param :country_name, String, required: true, desc: 'Nombre del país de origen'
    param :country_code, String, required: true, desc: 'Código del país según ISO 3166-1'
  end

  param :pickup_address, Hash, required: true, desc: 'Información acerca de la dirección de origen' do
    param :street_name, String, required: true, desc: 'Nombre de la calle de origen'
    param :street_number, Integer, required: true, desc: 'Número de la calle de origen'
    param :floor_number, Integer, required: false, desc: 'Número del piso de origen'
    param :apartment, String, required: false, desc: 'Apartamento de origen'
    param :lat, String, required: false, desc: 'Latitud de origen'
    param :lng, String, required: false, desc: 'Longitud de origen'
  end

  param :delivery_location, Hash, required: true, desc: 'Información acerca del destino' do
    param :city_name, String, required: true, desc: 'Nombre de la ciudad de destino'
    param :region_name, String, required: true, desc: 'Nombre de la región de destino'
    param :country_name, String, required: true, desc: 'Nombre del país de destino'
    param :country_code, String, required: true, desc: 'Código del país según ISO 3166-1'
  end

  param :delivery_address, Hash, required: true, desc: 'Información acerca de la dirección de destino' do
    param :street_name, String, required: true, desc: 'Nombre de la calle de destino'
    param :street_number, Integer, required: true, desc: 'Número de la calle de destino'
    param :floor_number, Integer, required: false, desc: 'Número del piso de destino'
    param :apartment, String, required: false, desc: 'Apartamento de destino'
    param :lat, String, required: true, desc: 'Latitud de destino'
    param :lng, String, required: true, desc: 'Longitud de destino'
  end

  param :pickup_service_condition, Hash, desc: 'Condiciones de servicio del origen' do
    param :type, %w(before_of after_of on between), required: true, desc: 'Tipo de condición de servicio'
    param :date, String, desc: 'Fecha, si se selecciona algún tipo before_of, after_of o on. Formato: YYYY-MM-DD'
    param :from_date, String, desc: 'Fecha de inicio, si se selecciona between. Formato: YYYY-MM-DD'
    param :to_date, String, desc: 'Fecha límite, si se selecciona between. Formato: YYYY-MM-DD'
    param :from_time, String, desc: 'Hora de inicio'
    param :from_time, String, desc: 'Hora límite'
  end

  param :delivery_service_condition, Hash, desc: 'Condiciones de servicio del destino' do
    param :type, %w(before_of after_of on between), required: true, desc: 'Tipo de condición de servicio'
    param :date, String, desc: 'Fecha, si se selecciona algún tipo before_of, after_of o on. Formato: YYYY-MM-DD'
    param :from_date, String, desc: 'Fecha de inicio, si se selecciona between. Formato: YYYY-MM-DD'
    param :to_date, String, desc: 'Fecha límite, si se selecciona between. Formato: YYYY-MM-DD'
    param :from_time, String, desc: 'Hora de inicio'
    param :from_time, String, desc: 'Hora límite'
  end
  
  param :items, Array, desc: 'Array de items a enviar', required: true do
    param :item_number, Hash, desc: 'Array con información del artículo', required: true do
      param :length_m, Integer, required:true, desc: 'Metros de largo'
      param :length_cm, Integer, required:true, desc: 'Centímetros de largo'
      param :width_m, Integer, required:true, desc: 'Metros de ancho'
      param :width_cm, Integer, required:true, desc: 'Centímetros de ancho'
      param :height_m, Integer, required:true, desc: 'Metros de alto'
      param :height_cm, Integer, required:true, desc: 'Centímetros de alto'
      param :weight_kg, Integer, required:true, desc: 'Peso en kilogramos'
      param :quantity, Integer, required:true, desc: 'Cantidad de ese tipo de artículos que se va a transportar'
    end
  end
  
  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "title": "Envío de muebles",
  "category": "furniture",
  "pickup_location": {
    "city_name": "San Francisco",
    "region_name": "Córdoba",
    "country_name": "Argentina",
    "country_code": "AR"
  },
  "pickup_address": {
    "street_name": "Jonas Salk",
    "street_number": 1160,
    "floor_number": 2,
    "apartment": "A",
    "lat": "-31.428373",
    "lng": "-62.084668"
  },
  "delivery_location": {
    "city_name": "Devoto",
    "region_name": "Córdoba",
    "country_name": "Argentina",
    "country_code": "AR"
  },
  "delivery_address": {
    "street_name": "25 de Mayo",
    "street_number": 236
  },
  "pickup_service_condition": {
    "type": "after_of",
    "date": "2017-01-01",
    "from_time": "15:50",
    "to_time": "17:35"
  },
  "delivery_service_condition": {
    "type": "between",
    "from_date": "2017-01-02",
    "to_date": "2017-01-03",
    "from_time": "12:30",
    "to_time": "16:00"
  },
  "items": [
    {
      "name": "Placard",
      "length_m": 1,
      "length_cm": 25,
      "width_m": 0,
      "width_cm": 30,
      "height_m": 2,
      "height_cm": 0,
      "weight_kg": 5,
      "quantity": 1
    },
    {
      "name": "Mesa",
      "length_m": 0,
      "length_cm": 90,
      "width_m": 0,
      "width_cm": 50,
      "height_m": 2,
      "height_cm": 23,
      "weight_kg": 2,
      "quantity": 2
    }
  ]
}


Ejemplo de respuesta:

{
  "id": 141
}
  EXAMPLE
  
  def create
    shipment_publication_form = ShipmentPublicationApiForm.new(@json)
    
    begin
      shipment_publication = @shipment_publication_service.create!(shipment_publication_form)
    rescue
      raise BadRequestException.new('Invalid JSON')
    end

    render json: shipment_publication.to_json(only: [:id])
  end
end