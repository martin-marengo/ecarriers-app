class ShipmentPublicationApiForm < AbstractForm
  def get_shipment_publication
    return ShipmentPublication.new(
      title: title,
      category: category,
      pickup_address: pickup_address,
      delivery_address: delivery_address,
      pickup_service_condition: pickup_service_condition,
      delivery_service_condition: delivery_service_condition,
      items: items
    )
  end
  
  private
  def title
    return @params[:title]
  end
  
  def category
    return Category.find_by(code_name: @params[:category])
  end
  
  def pickup_address
    location_form = LocationForm.new(@params[:pickup_address], @params[:pickup_location])
    
    return SetupAddressService.new.call location_form
  end
  
  def delivery_address
    location_form = LocationForm.new(@params[:delivery_address], @params[:delivery_location])
  
    return SetupAddressService.new.call location_form
  end
  
  def pickup_service_condition
    return ServiceConditionForm.new(@params[:pickup_service_condition]).get_service_condition
  end
  
  def delivery_service_condition
    return ServiceConditionForm.new(@params[:delivery_service_condition]).get_service_condition
  end
  
  def items
    return ItemsForm.new(@params[:items]).get_items
  end
end