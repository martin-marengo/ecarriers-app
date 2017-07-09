# Controller para realizar una nueva publicacion de envio por parte de un usuario, a traves de un wizard
class ShipmentPublicationController < ApplicationController
  include Wicked::Wizard, ServiceConditionHelper
  
  def initialize(
    setup_address_service = SetupAddressService.new
  )
    super()
    
    @setup_address_service = setup_address_service
  end

  CATEGORY_ID_PARAM = :category_id
  NUMBER_OF_CATEGORIES_SHOWN = 6
  BEFORE_OF_CONDITION = :before_of
  AFTER_OF_CONDITION = :after_of
  ON_CONDITION = :on
  BETWEEN_CONDITION = :between
  
  before_action :authenticate_user!

  skip_before_filter :item_info, only: :item_info
  
  helper_method :parent_categories, :next_category_step_path, :children_categories,
                :categories_to_show_in_row, :show_errors?, :service_conditions,
                :default_service_condition, :street_text, :city_text, :service_condition_text,
                :publication_path
  
  steps :select_parent_category, :select_child_category, :publication_info, :addresses_info, :check_info, :successful_publication

  def show
    case step
      when :select_parent_category
      when :select_child_category
        @parentCategory = get_category; return if performed?
        
      when :publication_info
        @shipmentPublication = ShipmentPublication.new
        @shipmentPublication.category = get_category; return if performed?
        @shipmentPublication.items << Item.new
        
      else
        redirect_to wizard_path(:select_parent_category)
        return
        
    end
    
    render_wizard
  end
  
  def update
    case step
      when :addresses_info
        @shipmentPublication = get_sent_shipment_publication
        @shipmentPublication.category = get_category; return if performed?
        @shipmentPublication.pickup_address = Address.default_address
        @shipmentPublication.delivery_address = Address.default_address
        @shipmentPublication.pickup_service_condition = ServiceCondition.default_service_condition
        @shipmentPublication.delivery_service_condition = ServiceCondition.default_service_condition
        
        if valid_shipment_in_publication_info_step? @shipmentPublication
          return render :addresses_info, locals: {shipment_publication: @shipmentPublication}
        else
          @show_errors_in_publication_info = true
          return render_step :publication_info
        end
        
      when :check_info
        @shipmentPublication = get_sent_shipment_publication
        @shipmentPublication.category = get_category; return if performed?
        @shipmentPublication.pickup_address = location_form(:pickup_address).address
        @shipmentPublication.delivery_address = location_form(:delivery_address).address
        @shipmentPublication.pickup_service_condition = get_service_condition :pickup_service_condition
        @shipmentPublication.delivery_service_condition = get_service_condition :delivery_service_condition
        @shipmentPublication.status = ShipmentPublication::STATUS_EVALUATING_BIDS
        
        if valid_shipment_in_addresses_info_step? @shipmentPublication
          return render :check_info, locals: {shipment_publication: @shipmentPublication}
        else
          @show_errors_in_publication_info = true
          return render_step :addresses_info
        end
        
      when :successful_publication
        shipmentPublication = get_sent_shipment_publication
        shipmentPublication.category = get_category
        shipmentPublication.pickup_address = @setup_address_service.call location_form(:pickup_address)
        shipmentPublication.delivery_address = @setup_address_service.call location_form(:delivery_address)
        shipmentPublication.pickup_service_condition = get_service_condition :pickup_service_condition
        shipmentPublication.delivery_service_condition = get_service_condition :delivery_service_condition
        shipmentPublication.status = ShipmentPublication::STATUS_EVALUATING_BIDS
        
        if shipmentPublication.save
          ShipmentPublicationMailer.published(shipmentPublication, current_user).deliver_later
    
          return render :successful_publication, locals: {shipment_publication: shipmentPublication, userMail: current_user.email}
        else
          redirect_to_first_step
        end
    end
  end
  
  def item_info
    number_of_articles = params[:number_of_articles].to_i
    
    render partial: 'article_info_form', locals: {item: Item.new, index: number_of_articles - 1}
  end

  private
  
  def shipment_publication_params
    return params.require(:shipment_publication).permit(
      :title, :special_care, :blanket_wrap,
      
      pickup_address: [:street_name, :street_number, :floor_number, :apartment, :location_description,
                       :city_name, :region_name, :country_name, :lat, :lng],
      delivery_address: [:street_name, :street_number, :floor_number, :apartment, :location_description,
                         :city_name, :region_name, :country_name, :lat, :lng],
      
      pickup_service_condition: [:date, :from_date, :to_date, :from_time, :to_time],
      delivery_service_condition: [:date, :from_date, :to_date, :from_time, :to_time]
    )
  end

  # @param [Symbol] where :pickup_address or :delivery_address
  def location_form(where)
    address_params = shipment_publication_params.require(where).slice(
      :street_name, :street_number, :floor_number, :apartment, :location_description, :lat, :lng)

    location_params = shipment_publication_params.require(where).slice(
      :city_name, :region_name, :country_name)
    
    return LocationForm.new address_params, location_params
  end

  def get_address(where)
    return Address.new(params.require(:shipment_publication)[where].permit(:street_name, :street_number, :location_description, :floor_number, :apartment))
  end

  def get_service_condition(where)
    kind_of_condition = params[where]
  
    case kind_of_condition
      when BEFORE_OF_CONDITION.to_s
        data = params.require(:shipment_publication).require(where).permit(:date, :from_time, :to_time)
        return BeforeCondition.new data
    
      when AFTER_OF_CONDITION.to_s
        data = params.require(:shipment_publication).require(where).permit(:date, :from_time, :to_time)
        return AfterCondition.new data
    
      when ON_CONDITION.to_s
        data = params.require(:shipment_publication).require(where).permit(:date, :from_time, :to_time)
        return OnCondition.new data
    
      when BETWEEN_CONDITION.to_s
        data = params.require(:shipment_publication).require(where).permit(:from_date, :to_date, :from_time, :to_time)
        return BetweenCondition.new data
    
      else
        return ServiceCondition.new
    end
  end

  # @return [ShipmentPublication]
  def get_sent_shipment_publication
    shipmentPublication = ShipmentPublication.new(params.require(:shipment_publication).permit(:title, :special_care, :blanket_wrap))
    shipmentPublication.client = current_user
  
    params.require(:item).each do |key, item|
      item_data = item.permit(:length_m, :length_cm, :width_m, :width_cm, :height_m, :height_cm,
                                 :weight_kg, :quantity, :name)
    
      shipmentPublication.items << Item.new(item_data)
    end
  
    return shipmentPublication
  end

  # @return [Boolean]
  def valid_shipment_in_publication_info_step? shipment
    shipment.items.each do |item|
      return false unless item.valid?
    end

    # Agregandole el .any? al final de errors[:title] no funciona
    return shipment.errors[:title]
  end

  def valid_shipment_in_addresses_info_step?(shipment)
    shipment.items.each do |item|
      return false unless item.valid?
    end
  
    return false unless shipment.pickup_address.valid?
  
    return false unless shipment.pickup_service_condition.valid?
  
    return false unless shipment.delivery_address.valid?
  
    return false unless shipment.delivery_service_condition.valid?
  
    return shipment.valid?
  end

  def get_category
    category_id = params[CATEGORY_ID_PARAM]
  
    if(category_id.nil?)
      redirect_to_first_step
      return
    end
  
    category = Category.find_by(id: category_id)
  
    if category.nil?
      redirect_to_first_step
      return
    end
  
    return category
  end

  def redirect_to_first_step
    redirect_to wizard_path(:select_parent_category)
  end

  #### Helper methods
  def show_errors?
    return (
    defined?(@show_errors_in_publication_info) &&
      (@show_errors_in_publication_info == true)
    )
  end

  def service_conditions
    return {'Antes de' => BEFORE_OF_CONDITION, 'Después de' => AFTER_OF_CONDITION, 'En' => ON_CONDITION, 'Entre' => BETWEEN_CONDITION }
  end

  def default_service_condition
    return BEFORE_OF_CONDITION
  end

  def parent_categories
    Category.parent_categories
  end

  def children_categories
    @parentCategory.categories
  end

  def next_category_step_path(category)
    if category.has_children
      "#{wizard_path(:select_child_category)}?#{CATEGORY_ID_PARAM}=#{category.id}"
    else
      "#{wizard_path(:publication_info)}?#{CATEGORY_ID_PARAM}=#{category.id}"
    end
  end

  def street_text(address)
    text = "#{address.street_name} #{address.street_number}"
    text += ", Piso #{address.floor_number} " unless address.floor_number.strip.empty?
    text += ", Departamento #{address.apartment} " unless address.apartment.strip.empty?
  
    return text
  end

  def city_text(address)
    return address.location_description
  end

  def service_condition_text(service_condition)
    if service_condition.instance_of? BeforeCondition
      return "Antes del #{date_formatted service_condition.date}, #{service_condition_time_text service_condition}"
  
    elsif service_condition.instance_of? AfterCondition
      return "Después del #{date_formatted service_condition.date}, #{service_condition_time_text service_condition}"
  
    elsif service_condition.instance_of? OnCondition
      return "El #{date_formatted service_condition.date}, #{service_condition_time_text service_condition}"
  
    elsif service_condition.instance_of? BetweenCondition
      return "Entre el #{date_formatted service_condition.from_date} y #{date_formatted service_condition.to_date}, #{service_condition_time_text service_condition}"
  
    end
  end

  # @param [ShipmentPublication] shipment_publication
  # @return [String] Url of shipment publication
  def publication_path(shipment_publication)
    #If we use `shipment_publications_path`, it will return the pluralized path instead of actual path. That's the
    #reason why we concatenate strings.
    #More info: http://stackoverflow.com/questions/5674116/path-helpers-generate-paths-with-dots-instead-of-slashes
    "/shipment_publications/#{shipment_publication.id}"
  end

  def date_formatted date
    return date.strftime("%d/%m/%Y")
  end

  def categories_to_show_in_row categories, iteration_number
    return categories[(from iteration_number)...(to iteration_number)]
  end

  def from(iteration_number)
    iteration_number*NUMBER_OF_CATEGORIES_SHOWN
  end

  def to(iteration_number)
    from(iteration_number) + NUMBER_OF_CATEGORIES_SHOWN
  end
end