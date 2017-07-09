class Conversation < ActiveRecord::Base
  belongs_to :topic, polymorphic: true

  has_many :messages, dependent: :destroy

  accepts_nested_attributes_for :messages, allow_destroy: true

  validates :topic, :messages, presence: true

  def title(current_person)
    title = 'Chat'
    other_person = other_person(current_person)
    if other_person
      if other_person.instance_of? User or other_person.instance_of? Seller
        title = other_person.full_name
      elsif other_person.instance_of? Carrier
        title = other_person.business_name
      end
    end
    return title
  end

  def other_person(current_person)
    if topic

      if topic.instance_of? Bid
        if current_person.instance_of? Carrier
          return self.topic.try(:shipment_publication).try(:client)
        elsif current_person.instance_of? User
          return self.topic.try(:carrier)
        end

      elsif topic.instance_of? ShipmentRequest
        if self.topic.try(:user).same_as(current_person)
          return self.topic.try(:user_trip_publication).try(:user)
        else
          return self.topic.try(:user)
        end
      end

    end
    return nil
  end

end