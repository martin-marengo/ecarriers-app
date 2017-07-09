class ApiCarriersController < BaseCarriersApiController
  
  def initialize
    super()
    
    @token_service = TokenService.new
    @shipment_publication_service = ShipmentPublicationService.new
  end
  
  
  
  api :POST, 'carriers/login/', 'Loguear un transportista, y obtener el token a usar'
  description 'Valida que los datos de autentificación enviados sean válidos. Si lo son, devuelve el token a usar en las futuras solicitudes'

  param :email, String, required: true, desc: 'Email del transportista'
  param :password, String, required: true, desc: 'Contraseña del transportista'

  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "email": "tranportista@transportista.com",
  "password": "my password"
}


Ejemplo de respuesta:

{
  "api_token":"mZPVDu65QF4NbSK--yH6rw"
}
  EXAMPLE
  
  def login
    email = @json[:email]
    password = @json[:password]
    
    carrier = Carrier.find_for_authentication(email: email)
    
    if !carrier.blank? and carrier.valid_password?(password)
      @token_service.assign_token carrier
      
      return render json: {api_token: carrier.api_token}
    else
      raise UnauthorizedException.new
    end
  end
  
  
  
  api :PATCH, 'shipment_publication/mark_as_being_shipped/', 'Establecer una publicación en estado "Siendo transportada"'
  description 'Establece el estado de la publicación en "Siendo transportada". Usado cuando se recoge un paquete.'
  
  param :api_token, String, required:true, desc: 'API Token'
  param :id, Integer, required: true, desc: 'ID de la publicación'
  
  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "id": 5
}


La respuesta es un código HTTP.
  EXAMPLE
  def mark_as_being_shipped
    shipment_publication = ShipmentPublication.find(@json[:id])
    
    @shipment_publication_service.mark_as_being_shipped! shipment_publication
    
    render json: {}
  end
  
  
  
  api :PATCH, 'shipment_publication/mark_as_delivered/', 'Establecer una publicación en estado "Entregado"'
  description 'Establece el estado de la publicación en "Entregado". Usado cuando se entrega un paquete.'
  
  param :api_token, String, required:true, desc: 'API Token'
  param :id, Integer, required: true, desc: 'ID de la publicación'
  
  example <<-EXAMPLE
Ejemplo de estructura de un JSON:

{
  "api_token": "gSh3IJB6gzckoi6DEfHtiw",
  "id": 5
}


La respuesta es un código HTTP.
  EXAMPLE
  def mark_as_delivered
    shipment_publication = ShipmentPublication.find(@json[:id])
    
    @shipment_publication_service.mark_as_delivered! shipment_publication
    
    render json: {}
  end
end
