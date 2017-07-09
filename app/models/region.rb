class Region < ActiveRecord::Base
  belongs_to :country
  has_many :cities

  validates :name, :country, presence: true
  validates :name, uniqueness: { scope: :country, case_sensitive: false }
end
