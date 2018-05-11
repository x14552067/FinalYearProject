class SessionChannel < ApplicationCable::Channel
  def subscribed
    stream_from "session_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_chat_message(data)

    #Take in the Payload from the sent Message
    @payload = data['message']

    #Get the contents of the paylod
    @content = @payload['content']
    @uid = @payload['uid']
    @utp = @payload['utp']
    @sid = @payload['sid']
    @anon = @payload['anon']


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
        @save_message.student = @user
      end

      if @anon == "t"
        @save_message.is_anon = true
      else
        @save_message.is_anon = false
      end

      if @save_message.save
        @payload['timestamp'] = @save_message.created_at.strftime('%H:%M')
        @payload['name'] = @user.full_name
        @payload['type'] = 'chat'
        ActionCable.server.broadcast "session_channel", message: @payload
      end

      #End of Message being authentic and sending code
    end
  end

  def send_question_message(data)

    #Take in the Payload from the sent Message
    @payload = data['message']

    #Get the contents of the paylod
    @content = @payload['content']
    @uid = @payload['uid']
    @utp = @payload['utp']
    @sid = @payload['sid']
    @anon = @payload['anon']


    #Parse the User ID and User Type (Checks if they are somehow Strings, if so, cancel the rest of the action)
    @uid = Integer(@uid) rescue -100
    @utp = Integer(@utp) rescue -100
    @sid = Integer(@sid) rescue -100

    #Cancelling in the case of String or Lecturer
    if @uid == -100 or @utp == -100 or @sid == -100 or @utp == 191

    else
      #This far means the message is A O K to send

      #Save the message to our DB
      @save_question = Questionmessage.new
      @save_question.content = @content

      #Get the Session for the Message and Associate them
      @session = Classsession.find(@sid)
      @save_question.classsession = @session

      #Get the User for the Message
      @user = User.find(@uid)

      if @utp == 191
        #lec
        @user = @user.lecturer
        @save_question.lecturer = @user

      elsif @utp == 4
        #stu
        @user = @user.student
        @save_question.student = @user
      end

      if @anon == "t"
        @save_question.is_anon = true
      else
        @save_question.is_anon = false
      end

      if @save_question.save
        @payload['timestamp'] = @save_question.created_at.strftime('%H:%M')
        @payload['name'] = @user.full_name
        @payload['type'] = 'question'
        ActionCable.server.broadcast "session_channel", message: @payload
      end

      #End of Message being authentic and sending code
    end
  end

  #End of Send Question Message Method

  def activate_poll(data)

    #Get the data passed in and get the type of poll from it
    @payload = data['message']
    @session_id = @payload['sid']

    #Create a poll and save it
    @active_poll = UnderstandingPoll.new
    @active_poll.classsession_id = @session_id

    #If it saves - Not necessary but incase this ever didn't work the system wont crash!
    if @active_poll.save
      #Get the generated ID
      @poll_id = @active_poll.id
      @payload['type'] = 'poll'
      @payload['poll_id'] = @poll_id
      ActionCable.server.broadcast "session_channel", message: @payload
    end
  end

  def poll_response(data)

    #Get the Data from the Payload
    @payload = data['message']
    @poll_id = @payload['pid']
    @user_id = @payload['uid']
    @response = @payload['answer']

    #Find the current poll
    @active_poll = UnderstandingPoll.find(@poll_id)

    #Get the current User and the Student associated
    @user = User.find(@user_id)
    @student = @user.student

    #Create the response to the poll
    @new_answer = UnderstandingResponse.new
    @new_answer.student = @student
    @new_answer.understanding_poll = @active_poll

    #Check if the Student understood or now
    if @response == 'y'
      @new_answer.understood = true
    else
      @response == 'n'
      @new_answer.understood = false
    end

    #Save the answer and if it saves, send the response back
    if @new_answer.save
      @payload['type'] = 'poll-response'
      ActionCable.server.broadcast "session_channel", message: @payload
    end

  end

  def update_poll_data(data)

    @payload = data['message']
    @poll_id = @payload['pid']

    @yes_count = UnderstandingResponse.where("understanding_poll_id = " + @poll_id + "AND understood = true")
    @yes_count = @yes_count.count

    @no_count = UnderstandingResponse.where("understanding_poll_id = " + @poll_id + "AND understood = false")
    @no_count = @no_count.count

    @payload['type'] = 'text-poll-update'
    @payload['yes'] = @yes_count
    @payload['no'] = @no_count

    ActionCable.server.broadcast "session_channel", message: @payload


  end


end
