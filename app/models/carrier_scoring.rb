class CarrierScoring < ActiveRecord::Base
  belongs_to :shipment_publication

  MIN_SCORE = 1
  MAX_SCORE = 5

  validates_presence_of :service_quality, :delivery_time
  validates_inclusion_of :service_quality, :delivery_time, :in => MIN_SCORE..MAX_SCORE, allow_blank: true
  # Don't use presence validator on boolean fields. Use inclusion validator instead:
  validates_inclusion_of :recommended, in: [true, false]

  def self.scoring_interval
    return MIN_SCORE..MAX_SCORE
  end

  def self.average_service_quality scorings
    service_quality = 0
    scorings.each do |scoring|
      service_quality += scoring.service_quality
    end
    (service_quality / scorings.size.to_f).ceil
  end

  def self.average_delivery_time scorings
    delivery_time = 0
    scorings.each do |scoring|
      delivery_time += scoring.delivery_time
    end
    (delivery_time / scorings.size.to_f).ceil
  end

  def self.recommended_quantity scorings
    recommended = 0
    scorings.each do |scoring|
      recommended += 1 if scoring.recommended
    end
    recommended
  end

end
