class PersonService
  
  # Check that current user is the same that user sent via parameter.
  # This method will raise an UnauthorizedException if they are different.
  # @param [User|Seller|Carrier] person
  # @raise UnauthorizedException
  def check_that_is_current_person(person)
    unless PersonService.current_person.eql? person
      raise UnauthorizedException.new
    end
  end
  
  def current_person
    PersonService.current_person
  end

  class << self
    def current_person=(person)
      Thread.current[:current_person] = person
    end
  
    def current_person
      Thread.current[:current_person]
    end
  end
end