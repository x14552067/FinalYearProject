# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addLecturerMessage = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  $('#chat-messages').append("<p class='lecturer-message'><span class='chat-timestamp'>" + timestamp + " </span> <span class='lecturer-name'>" + name + "</span>: " + message_content + "</p>")

  # https://stackoverflow.com/questions/7303948/how-to-auto-scroll-to-end-of-div-when-data-is-added
  messages = document.getElementById('chat-messages');
  messages.scrollTop = messages.scrollHeight;

addStudentMessage = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  if(payload['anon'] == "t")
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> Anonymous: " + message_content + "</p>")
  else
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> " + name + ": " + message_content + "</p>")

  messages = document.getElementById('chat-messages');
  messages.scrollTop = messages.scrollHeight;

#Subscribe to the Session
App.session = App.cable.subscriptions.create "SessionChannel",
  connected: ->
# Called when the subscription is ready for use on the server


  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    payload = data['message']

    if(payload['utp'] == "191")
      addLecturerMessage(payload)
    else
      addStudentMessage(payload)



  send_message: (type) ->

    #build the Payload to be sent to session_channel.rb

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

  $(document).on 'keypress', '[data-behavior~=chat_send]', (event) ->
    if event.keyCode is 13 # return/enter = send
      App.session.send_message("c")
      event.preventDefault()

  activate_interactions = ->

    messages = document.getElementById('chat-messages');
    messages.scrollTop = messages.scrollHeight;

    $(".chat-btn").on 'click', (event) ->
      App.session.send_message("c")
      event.preventDefault()

  $(document).ready(activate_interactions)