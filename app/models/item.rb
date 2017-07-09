class Item < ActiveRecord::Base
  belongs_to :shipment_publication

  MAX_METERS = 50
  MIN_METERS = 0
  MIN_CENTIMETERS = 0
  MAX_CENTIMETERS = 99
  MAX_WEIGHT_KG = 1000000.0
  MIN_WEIGHT_KG = 0.01
  MAX_QUANTITY = 1000000
  MIN_QUANTITY = 1

  validates :name, :shipment_publication, :quantity, presence: true

  validates :quantity, numericality: { greater_than_or_equal_to: 1 }, allow_blank: true
  validates :quantity, numericality: { less_than_or_equal_to: MAX_QUANTITY }, allow_blank: true

  # La lógica con las categorías tiene que ser la siguiente:
  # Si requiere medidas y peso, se validan si o si.
  # Si no requieren, no se validan a menos que esten presentes.
  validates :length_m, :width_m, :height_m, :length_cm, :width_cm, :height_cm, presence: true, if: :should_validate_measures?
  validates :weight_kg, presence: true, if: :should_validate_weight?

  # If measure was input, check that if is a number, and is between range
  validates :length_m, :width_m, :height_m, numericality: { greater_than_or_equal_to: MIN_METERS }, allow_blank: true
  validates :length_m, :width_m, :height_m, numericality: { less_than_or_equal_to: MAX_METERS }, allow_blank: true
  validates :length_cm, :width_cm, :height_cm, numericality: { greater_than_or_equal_to: MIN_CENTIMETERS }, allow_blank: true
  validates :length_cm, :width_cm, :height_cm, numericality: { less_than_or_equal_to: MAX_CENTIMETERS }, allow_blank: true
  validates :weight_kg, numericality: { greater_than_or_equal_to: MIN_WEIGHT_KG }, allow_blank: true
  validates :weight_kg, numericality: { less_than_or_equal_to: MAX_WEIGHT_KG }, allow_blank: true

  def length
    text = ''
    if length_m and length_cm
      text = length_m.to_s + '.' + length_cm.to_s
    end
    return text
  end

  def width
    text = ''
    if width_m and width_cm
      text = width_m.to_s + '.' + width_cm.to_s
    end
    return text
  end

  def height
    text = ''
    if height_m and height_cm
      text = height_m.to_s + '.' + height_cm.to_s
    end
    return text
  end

  def weight
    text = ''
    if weight_kg
      text = weight_kg.to_s
    end
    return text
  end

  private

  def should_validate_measures?
    if shipment_publication.category
      shipment_publication.category.are_measures_required? || any_measure_present?
    else
      # si alguno está presente, tienen que estarlo todos y se validan
      any_measure_present?
    end
  end

  def should_validate_weight?
    if shipment_publication.try(:category)
      shipment_publication.category.is_weight_required? || weight_kg
    else
      # si el peso está presente, se valida
      weight_kg
    end
  end

  def any_measure_present?
    length_m || width_m || height_m || length_cm || width_cm || height_cm
  end

end
