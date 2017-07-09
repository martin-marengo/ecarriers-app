class LocationReport < ActiveRecord::Base
  belongs_to :trip

  validates :trip, :lat, :lng, presence: true
  
  #TODO: Validate lat and lng valid values (Between)
end
