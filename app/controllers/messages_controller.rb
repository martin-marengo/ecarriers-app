class MessagesController < ApplicationController
  include ConversationMails

  before_action :authenticate_person!, :set_current_person

  def create
    @message = Message.new(messages_params)
    @message.person = @current_person
    @conversation = @message.conversation

    # Set up new message
    @new_message = @conversation.messages.build
    @new_message.conversation = @conversation
    
    respond_to do |format|
      if @message.save

        send_email_to_receiver(@conversation, @message, @current_person)

        format.js
      else
        format.js { flash.now[:error] = 'No se ha enviado el mensaje, vuelva a intentar en un momento.' }
      end
    end
  end

  private

  def messages_params
    params.require(:message).permit(:body, :conversation_id)
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
end