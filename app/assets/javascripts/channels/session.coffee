# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

###########################################################################################
#                       Code for Adding Messages Dynamically to pages                     #
###########################################################################################

add_lecturer_message = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  $('#chat-messages').append("<p class='lecturer-message'><span class='chat-timestamp'>" + timestamp + " </span> <span class='lecturer-name'>" + name + "</span>: " + message_content + "</p>")

  # https://stackoverflow.com/questions/7303948/how-to-auto-scroll-to-end-of-div-when-data-is-added
  messages = document.getElementById('chat-messages');
  messages.scrollTop = messages.scrollHeight;

add_student_message = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  if(payload['anon'] == "t")
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> Anonymous: " + message_content + "</p>")
  else
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> " + name + ": " + message_content + "</p>")

  messages = document.getElementById('chat-messages');
  messages.scrollTop = messages.scrollHeight;

add_question_message = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  if(payload['anon'] == "t")
    $('#question-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> Anonymous: " + message_content + "</p>")
  else
    $('#question-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> " + name + ": " + message_content + "</p>")

  messages = document.getElementById('chat-messages');
  messages.scrollTop = messages.scrollHeight;

###########################################################################################
#                       Code for Adding Polls Dynamically to pages                        #
###########################################################################################


start_text_poll = (payload) ->
#Show a Poll Div inside interaction Div
  id = payload

  #Show the Poll
  $('#text-poll-div').slideToggle();

  #Set the poll's ID
  $('#pid').text('' + id)


start_image_poll = (payload) ->
  id = payload

  #Show the Poll
  $('#image-poll-div').slideToggle();

  #Set the poll's ID
  $('#pid').text('' + id)

#Slide Toggle a Lecturer Poll Div and append the graph inside it???
#Either append 2 buttons or just make them visible (Append then remove stops malicious clicking
#Make sure on listeners are ready to submit answer
#Populate the Poll Div with the Polls ID
#On click of Y/N, take the ID and post it back in a text poll response message
#Method in controller Creates a new response, does all the association
#Stop showing the poll answer option locally
#Pop up a graph for lecturer to be dynamically updated! (Could allow everyone to see maybe with a setting option
#This would only take an extra if and param initially passed in - look into it!


#Update the poll results based on controller data
update_text_poll_graph = (data) ->
  payload = data['message']

  yes_votes = payload['yes']
  no_votes = payload['no']

  data =
    Yes: yes_votes
    No: no_votes

  chart = Chartkick.charts["poll-responses"]

  chart.updateData(data)

#Interestingly, to end the poll we only have to hide the div. This would technically allow us to see the answers if we
# didnt reset the graph. Thanks to the way a poll is started, the old one will be overwritten and everything is persisted
#During operation so theres no need to do any final commits!
end_poll = () ->
  $('#text-poll-div').slideToggle()

  data =
    Yes: 0
    No: 0

  chart = Chartkick.charts["poll-responses"]

  chart.updateData(data)

###########################################################################################
#                       Code for Adding Quizzes Dynamically to Pages                      #
###########################################################################################

start_quiz = (questions) ->
  #Set the auld Questions text
  $('#quiz-question-one-text').text('' + questions['q1'])
  $('#quiz-question-two-text').text('' + questions['q2'])
  $('#quiz-question-three-text').text('' + questions['q3'])
  $('#quiz-question-four-text').text('' + questions['q4'])
  $('#quiz-question-five-text').text('' + questions['q5'])

  #Display the Questions!
  $('#quiz-question-div').slideToggle()




###########################################################################################
#                       Code for Changing State of Interaction Buttons                    #
###########################################################################################

toggle_interaction_buttons = (interaction) ->

#This means a Poll is Active or a Quiz is Active
  if interaction == "active"
    $('#poll-class-understanding-text').prop('disabled', true);
    $('#poll-class-understanding-image').prop('disabled', true);
    $('.quiz-btn').prop('disabled', true)
    $('#end-poll').prop('disabled', false);
    $('#end-quiz').prop('disabled', false);

#This means the current Interaction ended
  else if interaction == "end"

    $('#poll-class-understanding-text').prop('disabled', false);
    $('#poll-class-understanding-image').prop('disabled', false);
    $('.quiz-btn').prop('disabled', false)
    $('#end-poll').prop('disabled', true);
    $('#end-quiz').prop('disabled', true);





###########################################################################################
#                   Code for Handling Websockets for a realtime session                   #
###########################################################################################

#Subscribe to the Session
App.session = App.cable.subscriptions.create "SessionChannel",

  connected: ->
# Called when the subscription is ready for use on the server


  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
# Called when there's incoming data on the websocket for this channel
    payload = data['message']

    if payload['type'] == 'chat'

      if(payload['utp'] == "191")
        add_lecturer_message(payload)
      else
        add_student_message(payload)

    else if payload['type'] == 'question'
      add_question_message(payload)

    else if payload['type'] == 'poll'
      if payload['poll_type'] == 'text'
#In the case of the user being a student, launch the poll
        if $('#utp').text() == "4"
          start_text_poll(payload['poll_id'])

      else if payload['poll_type'] == 'image'
        if $('#utp').text() == "4"
          start_image_poll(payload['poll_id'])

    else if payload['type'] == 'poll-response'
      App.session.update_text_poll_graph_data()

    else if payload['type'] == 'text-poll-update' and $('#utp').text() == '191'
      update_text_poll_graph(data)

#Check if the payload contains a field called q1, this means a quiz is incoming
    else if 'q1' of payload
      if $('#utp').text() == "4"
        start_quiz(payload)




###########################################################################################
#                   Code for Sending Messages over Web Socket                             #
###########################################################################################


#Method for handling sending messages
#This method is unfortunately cumbersome due to the differences in messages
#Perhaps a refactor into methods for each type of message but it will basically be the same without the ifs
  send_message: (type) ->

#Check if they are sending the message anonymously
#This check figures out the type of message (Q - Question C - Chat)
    if type == "c"

#Get the Input form the Text box and set it back to blank
      content = $('#chat-input').val()
      $('#chat-input').val('')

      #Check if the User wishes to remain Anonymous
      if($('#chat-anon-box').is(":checked"))
        anon = "t"
      else
        anon = "f"

      #Add items to the payload
      payload =
        uid: $('#uid').text()
        utp: $('#utp').text()
        sid: $('#sid').text()
        anon: anon
        content: content

      console.log(payload)

      #Call relevant method from session_channel.rb
      @perform 'send_chat_message', message: payload


    else if type == "q"

#Get the Input form the Text box and set it back to blank
      content = $('#question-input').val()
      $('#question-input').val('')

      #Check if the User wishes to remain Anonymous
      if($('#question-anon-box').is(":checked"))
        anon = "t"
      else
        anon = "f"

      #Add items to the payload
      payload =
        uid: $('#uid').text()
        utp: $('#utp').text()
        sid: $('#sid').text()
        anon: anon
        content: content

      #Call relevant method from session_channel.rb
      @perform 'send_question_message', message: payload

    else if type = "a"

    else
      anon = "f"
# End of Send Message Method

###########################################################################################
#                   Code for Polling the Class over Websocket                             #
###########################################################################################


  poll_class: (type) ->
    payload =
      poll_type: type
      sid: $('#sid').text()

    @perform 'activate_poll', message: payload

  poll_response: (answer) ->
    payload =
      pid: $('#pid').text()
      answer: answer
      uid: $('#uid').text()

    console.log(payload)

    @perform 'poll_response', message: payload


#Get the current Poll data from the Controller
  update_text_poll_graph_data: () ->
    payload =
      pid: $('#pid').text()

    @perform 'update_poll_data', message: payload

###########################################################################################
#                   Code for Quizzing the Class over Websocket                            #
###########################################################################################

  quiz_class: (quiz_id) ->
    payload =
      quiz_id: quiz_id
      sid: $('#sid').text()

    @perform 'activate_quiz', message: payload

  quiz_response: () ->

    payload =
      a1: $('#question-one-field').val()
      a2: $('#question-two-field').val()
      a3: $('#question-three-field').val()
      a4: $('#question-four-field').val()
      a5: $('#question-five-field').val()
      qid: $('#qid').text()
      uid: $('#uid').text()

    @perform 'quiz_response'


###########################################################################################
#                   Code for Handling all the Realtime Inputs                             #
###########################################################################################


  $(document).on 'keypress', '[data-behavior~=chat_send]', (event) ->
    if event.keyCode is 13 # return/enter = send
      App.session.send_message("c")
      event.preventDefault()

  $(document).on 'keypress', '[data-behavior~=question_send]', (event) ->
    if event.keyCode is 13 # return/enter = send
      App.session.send_message("q")
      event.preventDefault()

#Stop Quizzes from accidentally submitting!
  $(document).on 'keypress', '[data-behavior~=quiz_send]', (event) ->
    if event.keyCode is 13 # return/enter = send
      event.preventDefault()

  activate_interactions = ->
    messages = document.getElementById('chat-messages');
    messages.scrollTop = messages.scrollHeight;

    $("#send-chat").on 'click', (event) ->
      App.session.send_message("c")
      event.preventDefault()

    $("#send-question").on 'click', (event) ->
      App.session.send_message("q")
      event.preventDefault()

    $("#poll-class-understanding-text").on 'click', (event) ->
      App.session.poll_class('text')
      toggle_interaction_buttons("active")
      $('#poll-response-pie').slideToggle()
      event.preventDefault()

    $("#poll-class-understanding-image").on 'click', (event) ->
      App.session.poll_class('image')
      toggle_interaction_buttons("active")
      $('#poll-response-pie').slideToggle()
      event.preventDefault()

    $("#end-poll").on 'click', (event) ->
      end_poll()
      toggle_interaction_buttons("end")
      $('#poll-response-pie').slideToggle()
      event.preventDefault()

    $('#text-poll-yes').on 'click', (event) ->
      App.session.poll_response('y')
      $('#text-poll-div').slideToggle()
      event.preventDefault()

    $('#text-poll-no').on 'click', (event) ->
      App.session.poll_response('n')
      $('#text-poll-div').slideToggle()
      event.preventDefault()

    $('#image-poll-yes').on 'click', (event) ->
      App.session.poll_response('y')
      $('#image-poll-div').slideToggle()
      event.preventDefault()

    $('#image-poll-no').on 'click', (event) ->
      App.session.poll_response('n')
      $('#image-poll-div').slideToggle()
      event.preventDefault()

    $('.quiz-btn').on 'click', (event) ->
      toggle_interaction_buttons("active")
      $('#quiz-response-graph').slideToggle()
      console.log($(this).parent().find('p').text())
      quiz_id = $(this).parent().find('p').text()
      App.session.quiz_class(quiz_id)

    $("#end-quiz").on 'click', (event) ->
#end_quiz()
      toggle_interaction_buttons("end")
      $('#quiz-response-graph').slideToggle()
      event.preventDefault()


      event.preventDefault()

    $('#send-quiz').on 'click', (event) ->
      App.session.quiz_response()
      $('#quiz-questions').slideToggle()
      event.preventDefault()



  $(document).ready(activate_interactions)