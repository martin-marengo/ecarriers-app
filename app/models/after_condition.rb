class AfterCondition < ServiceCondition
  validates :date, presence: true
  validates :from_date, absence: true
  validates :to_date, absence: true
end
# rails g model AfterCondition --parent ServiceCondition