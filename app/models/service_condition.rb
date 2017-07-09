class ServiceCondition < ActiveRecord::Base
  has_one :shipment_publication, foreign_key: :pickup_service_condition_id
  has_one :shipment_publication, foreign_key: :delivery_service_condition_id

  TO_TIME_ERROR_MESSAGE = 'debe ser posterior al horario de comienzo'

  validates :type, presence: true
  
  # Si existe to, debe existir from (es valido que exista sólo from, o que sean iguales).
  validates :from_time, presence: true, if: :to_time?
  
  # custom validations
  validate :valid_times?
  
  def self.default_service_condition
     return ServiceCondition.new
  end

  private

  def valid_times?
    if from_time && to_time
      errors[:to_time] << TO_TIME_ERROR_MESSAGE if to_time < from_time
    end
  end

  def to_time?
    to_time
  end

end
# Single table inheritance:
# http://eewang.github.io/blog/2013/03/12/how-and-when-to-use-single-table-inheritance-in-rails/
# http://www.archonsystems.com/devblog/2011/12/20/rails-single-table-inheritance-with-polymorphic-association/