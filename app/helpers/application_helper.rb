module ApplicationHelper

  PICKUP_TEXT = 'Retirar: '
  DELIVERY_TEXT = 'Entregar: '
  BEFORE_CONDITION_TEXT = 'antes del '
  AFTER_CONDITION_TEXT = 'despúes del '
  BETWEEN_CONDITION_TEXT_1 = 'entre el '
  BETWEEN_CONDITION_TEXT_2 = ' y el '

  READY_NOW_PICKUP = 'listo para retirar'
  ASAP_DELIVERY = 'lo antes posible'

  ORIGIN_DEFAULT_TEXT = 'Sin información'
  DESTINATION_DEFAULT_TEXT = 'Sin información'
  DISTANCE_DEFAULT_TEXT = 'Sin información'
  DIMENSIONS_DEFAULT_TEXT = 'Sin especificar'
  WEIGHT_DEFAULT_TEXT = 'Sin especificar'

  PROFILE_IMG_SIZE = '75x75'
  CATEGORY_ITEM_IMG_SIZE = '60x60'
  AVATAR_IMG_SIZE = '50x50'

  def short_date(date)
    if date
      date.strftime('%d/%m/%Y')
    else
      ''
    end
  end

  def mid_date(date)
    if date
      I18n.localize(date, format: '%d de %B de %Y')
    else
      ''
    end
  end

  def bootstrap_class_for flash_type
    { success: 'alert-success', error: 'alert-danger', alert: 'alert-warning',
      notice: 'alert-info' }[flash_type.to_sym] || flash_type.to_s
  end

  def show_messages(opts = {})
    if defined?(resource) && resource.errors.any?
      render partial: 'shared/error_messages', locals: {model: resource}
    elsif defined?(flash) && flash.any?
      render partial: 'shared/flash_messages', locals: {flash: flash}
    end
  end

  def show_errors_of(model)
    if defined?(model) && model.errors.any?
      render partial: 'shared/error_messages', locals: {model: model}
    end
  end

  def flash_messages(opts = {})
    show_messages opts
  end

  def distance_text(loc1, loc2)
    if loc1 and loc2
      km = distance_in_km(loc1, loc2)
      km = km.round(1)
      "#{km.to_s} km"
    else
      DISTANCE_DEFAULT_TEXT
    end
  end

  def controller?(*controller)
    controller.include?(params[:controller])
  end

  def action?(*action)
    action.include?(params[:action])
  end

  private

  # Cada loc es [lat, lng], del tipo float
  # @param [Array[float, float]] loc1
  # @param [Array[float, float]] loc2
  def distance_in_km(loc1, loc2)
    # PI / 180
    rad_per_deg = Math::PI/180
    # Earth radius in kilometers
    rkm = 6371
    # Radius in meters
    rm = rkm * 1000

    # Delta, converted to rad
    dlat_rad = (loc2[0]-loc1[0]) * rad_per_deg
    dlon_rad = (loc2[1]-loc1[1]) * rad_per_deg

    lat1_rad, lon1_rad = loc1.map {|i| i * rad_per_deg }
    lat2_rad, lon2_rad = loc2.map {|i| i * rad_per_deg }

    a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

    # Delta in meters
    delta_m = rm * c
    # Delta in kilometers
    delta_m / 1000
  end

  # Texto sin acentos, en minuscula y con los espacios reemplazados por guiones. Se usa para colocar como
  # id o clase de un elemento en html. Hyphens es el nombre que se le da a esa norma de puntuación.
  def hyphens_format(text)
    text ? text.gsub(' ', '-').downcase.strip_accent_marks : ''
  end

end
