class SessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "session_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(data)

    #Take in the Payload from the sent Message
    @payload = data['message']

    #Get the contents of the paylod
    @content = @payload['content']
    @uid = @payload['uid']
    @utp = @payload['utp']
    @sid = @payload['sid']

    #Parse the User ID and User Type (Checks if they are somehow Strings, if so, cancel the rest of the action)
    @uid = Integer(@uid) rescue -100
    @utp = Integer(@utp) rescue -100
    @sid = Integer(@sid) rescue -100

    #Cancelling in the case of String
    if @uid == -100 or @utp == -100 or @sid == -100

    else
      #This far means the message is A O K to send

      #Save the message to our DB
      @save_message = Chatmessage.new
      @save_message.content = @content

      #Get the Session for the Message and Associate them
      @session = Classsession.find(@sid)
      @save_message.classsession = @session

      #Get the User for the Message
      @user = User.find(@uid)

      if @utp == 191
        #lec
        @user = @user.lecturer
        @save_message.lecturer = @user

      elsif @utp == 4
        #stu
        @user = @user.student
        @save_message.student= @user
      end

      if @save_message.save
        ActionCable.server.broadcast "session_channel", message: @payload
      end

    #End of Message being authentic and sending code
    end
  end
end
