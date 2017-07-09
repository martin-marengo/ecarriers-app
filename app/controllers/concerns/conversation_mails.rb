module ConversationMails

  # Both ConversationsController and MessagesController can send emails through this method.
  def send_email_to_receiver(conversation, current_message, current_person)
    if current_person.is_a?(Carrier)
      # The topic is a bid
      MessagesMailer.carrier_bid_comment(conversation, current_message).deliver_later
    end
    if current_person.is_a?(User)
      if conversation.topic and conversation.topic.instance_of?(Bid)
        # The topic is a bid
        MessagesMailer.user_bid_comment(conversation, current_message).deliver_later
      else
        # The topic is a shipment request
        if current_person.same_as conversation.topic.user
          MessagesMailer.shipment_request_owner_comment(conversation, current_message).deliver_later
        else
          MessagesMailer.shipment_request_traveler_comment(conversation, current_message).deliver_later
        end
      end
    end
  end

end