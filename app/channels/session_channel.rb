class SessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "room_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)

    @sent_message = Chatmessage.new
    @sent_message.content = data['message']

    ActionCable.server.broadcast "room_channel", message: data['message']

  end
end
