class Trip < ActiveRecord::Base
  has_many :shipment_publications, autosave: true
  has_many :location_reports
  
  belongs_to :carrier
  belongs_to :origin, class_name: 'City'
  belongs_to :destination, class_name: 'City'
  
  STATUS_HAVE_TO_FETCH_ITEMS = 'have_to_pick_up_items'
  STATUS_DRIVING = 'driving'
  STATUS_FINISHED = 'finished'
  
  validates :carrier, :origin, :destination, :departure_date, :arrival_date, :shipment_publications, presence: true
  validate :valid_dates?
  
  # Status must be valid
  validates_inclusion_of :status, in: [
    STATUS_HAVE_TO_FETCH_ITEMS,
    STATUS_DRIVING, STATUS_FINISHED
  ]
  
  scope :not_finished, -> (current_carrier) {
    where(carrier: current_carrier).where.not(status: STATUS_FINISHED)
  }

  scope :ready_to_mark_as_driving, -> (current_carrier) {
    where(carrier: current_carrier).where(status: STATUS_HAVE_TO_FETCH_ITEMS)
  }

  scope :ready_to_mark_as_finished, -> (current_carrier) {
    where(carrier: current_carrier).where(status: STATUS_DRIVING)
  }
  
  def has_shipment_publication?(shipment_publication)
    shipment_publications.include? shipment_publication
  end
  
  def items_were_delivered
    status.eql? STATUS_FINISHED
  end
  
  def is_driving?
    return status.eql? STATUS_DRIVING
  end
  
  def valid_dates?
    if departure_date && arrival_date
      errors[:departure_date] << 'La fecha de salida debe ser menor o igual a la de llegada' if arrival_date < departure_date
    end
  end
end
