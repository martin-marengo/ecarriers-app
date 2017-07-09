class DestinationStatistic
  attr_accessor :place_name, :number
  
  def initialize(place_name, number)
    @place_name = place_name
    @number = number
  end
end