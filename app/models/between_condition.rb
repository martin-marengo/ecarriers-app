class BetweenCondition < ServiceCondition

  validates :from_date, presence: true
  validates :to_date, presence: true
  validates :date, absence: true
  # custom validations
  validate :valid_to_date

  TO_DATE_ERROR_MESSAGE = 'debe ser posterior a la fecha de comienzo'

  private

  def valid_to_date
    if from_date && to_date
      errors[:to_date] << TO_DATE_ERROR_MESSAGE if to_date <= from_date
    end
  end
end
# rails g model BetweenCondition --parent ServiceCondition
