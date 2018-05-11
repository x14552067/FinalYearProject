require 'json'
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

  def activate_quiz(data)

    #Get the data passed in and get the type of poll from it
    @payload = data['message']
    @session_id = @payload['sid']
    @quiz_id = @payload['quiz_id']

    #Get the Quiz and its questions
    @quiz = Quiz.find(@quiz_id)
    @quiz_questions = @quiz.quizquestions

    @question_one = @quiz_questions.find(1)
    @question_two = @quiz_questions.find(2)
    @question_three = @quiz_questions.find(3)
    @question_four = @quiz_questions.find(4)
    @question_five = @quiz_questions.find(5)

    @question_payload = {
        'q1' => @question_one.question_text,
        'q2' => @question_two.question_text,
        'q3' => @question_three.question_text,
        'q4' => @question_four.question_text,
        'q5' => @question_five.question_text,
        'qid' => @quiz.id
    }

    #Send Back the Questions to Display over MQTT
    ActionCable.server.broadcast "session_channel", message: @question_payload
  end

  #Could probably refactor this method to use a for loop if I have time!
  # Logic would simply iterate a counter from 1 - 5 and use that to reference
  # @payload['a' + counter] and create a new question and assign it to a student etc etc and then I could
  # Also use that counter to reference the @quiz_questions.find(counter)

  def quiz_response(data)

    #Get the Data from the Payload
    @payload = data['message']
    @quiz_id = @payload['qid']
    @user_id = @payload['uid']

    #Get all the Answers from the Payload
    @answer_one = @payload['a1']
    @answer_two = @payload['a2']
    @answer_three = @payload['a3']
    @answer_four = @payload['a4']
    @answer_five = @payload['a5']

    #Find the current poll
    @active_quiz = Quiz.find(@quiz_id)

    #Get the current User and the Student associated
    @user = User.find(@user_id)
    @student = @user.student

    #Get the 5 Questions for the Quiz
    @question_one = @quiz_questions.find(1)
    @question_two = @quiz_questions.find(2)
    @question_three = @quiz_questions.find(3)
    @question_four = @quiz_questions.find(4)
    @question_five = @quiz_questions.find(5)


    #Create 5 Quiz Responses, Associate them to the Questions and populate their answer
    @question_one_answer = Quizquestionresponse.new
    @question_one_answer.answer = @answer_one
    @question_one_answer.student = @student

    @question_two_answer = Quizquestionresponse.new
    @question_two_answer.answer = @answer_two
    @question_two_answer.student = @student

    @question_three_answer = Quizquestionresponse.new
    @question_three_answer.answer = @answer_three
    @question_three_answer.student = @student

    @question_four_answer = Quizquestionresponse.new
    @question_four_answer.answer = @answer_four
    @question_four_answer.student = @student

    @question_five_answer = Quizquestionresponse.new
    @question_five_answer.answer = @answer_five
    @question_five_answer.student = @student

    #Relate the Responses to the Question
    @question_one_answer.quizquestion = @question_one
    @question_two_answer.quizquestion = @question_two
    @question_three_answer.quizquestion = @question_three
    @question_four_answer.quizquestion = @question_four
    @question_five_answer.quizquestion = @question_five

    #Figure out if the Answers are correct then flag it accordingly
    if @question_one_answer.answer == @question_one.question_answer
      @question_one_answer.correct = true
    else
      @question_one_answer.correct = false
    end
    if @question_two_answer.answer == @question_two.question_answer
      @question_two_answer.correct = true
    else
      @question_two_answer.correct = false
    end
    if @question_three_answer.answer == @question_three.question_answer
      @question_three_answer.correct = true
    else
      @question_three_answer.correct = false
    end
    if @question_four_answer.answer == @question_four.question_answer
      @question_four_answer.correct = true
    else
      @question_four_answer.correct = false
    end
    if @question_five_answer.answer == @question_five.question_answer
      @question_five_answer.correct = true
    else
      @question_five_answer.correct = false
    end

    #Save the answers and respond back to the channel
    @question_one_answer.save
    @question_two_answer.save
    @question_three_answer.save
    @question_four_answer.save
    @question_five_answer.save

    @payload['type'] = 'quiz-response'
    ActionCable.server.broadcast "session_channel", message: @payload

  end


end
