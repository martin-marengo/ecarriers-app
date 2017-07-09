class OnCondition < ServiceCondition
  validates :date, presence: true
  validates :from_date, absence: true
  validates :to_date, absence: true
end
# rails g model OnCondition --parent ServiceCondition