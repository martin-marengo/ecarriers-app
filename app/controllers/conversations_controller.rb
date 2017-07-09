class ConversationsController < ApplicationController
  include ConversationMails

  before_action :authenticate_person!, :set_current_person

  def new_from_bid
    bid = get_bid new_from_bid_param[:bid_id]
    setup_new_conversation bid
    render 'new'
  end

  def new_from_shipment_request
    shipment_request = get_shipment_request new_from_shipment_request_param[:shipment_request_id]
    setup_new_conversation shipment_request
    render 'new'
  end

  def create
    @conversation = Conversation.new(conversation_params)

    # Just in case, but should be the first (and only) message within the next iterator.
    current_message = Message.new conversation_params[:messages_attributes][0]

    # Should be only one message
    @conversation.messages.each_with_index do |message,index|
      current_message = message if index == 0
      message.person = @current_person
      message.conversation = @conversation
    end
    
    respond_to do |format|
      if @conversation.save

        send_email_to_receiver(@conversation, current_message, @current_person)

        setup_new_message(@conversation)

        format.js
      else
        format.js { flash.now[:error] = 'No se ha enviado el mensaje, vuelva a intentar en un momento.' }
      end
    end
  end

  def edit
    @conversation = Conversation.includes(:topic, :messages).find(params[:id])
    
    # Create one empty message
    @new_message = @conversation.messages.build
  end

  private

  def conversation_params
    params.require(:conversation).permit(:topic_id, :topic_type, messages_attributes: [:id, :body, :person])
  end

  def set_current_person
    if current_person
      @current_person = current_person
    else
      prev = Rails.application.routes.recognize_path(request.referrer)
      
      if prev[:controller]
        if prev[:controller].equal?('shipment_publications')
          redirect_to_user
        elsif prev[:controller].equal?('bids')
          redirect_to_carrier
        end
      else
        # Default
        redirect_to_user
      end
    end
  end

  def redirect_to_user
    redirect_to new_user_session_path, notice: 'No has iniciado sesión.'
  end

  def redirect_to_carrier
    redirect_to new_carrier_session_path, notice: 'No has iniciado sesión.'
  end

  def get_bid(bid_id)
    bid_id ? Bid.find(bid_id) : nil
  end

  def get_shipment_request(shipment_request_id)
    shipment_request_id ? ShipmentRequest.find(shipment_request_id) : nil
  end

  def new_from_bid_param
    params.permit(:bid_id)
  end

  def new_from_shipment_request_param
    params.permit(:shipment_request_id)
  end

  def setup_new_message(conversation)
    @new_message = conversation.messages.build
    @new_message.conversation = conversation
  end

  def setup_new_conversation(topic)
    @conversation = Conversation.new

    @conversation.topic = topic if topic

    # Create one empty message
    @conversation.messages.build
  end

end