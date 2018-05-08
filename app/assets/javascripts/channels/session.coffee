# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

addLecturerMessage = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  $('#chat-messages').append("<p class='lecturer-message'><span class='chat-timestamp'>" + timestamp + " </span> <span class='lecturer-name'>" + name + "</span>: " + message_content + "</p>")

addStudentMessage = (payload) ->
  message_content = payload['content']
  timestamp = payload['timestamp']
  name = payload['name']

  if(payload['anon'] == "t")
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> Anonymous: " + message_content + "</p>")
  else
    $('#chat-messages').append("<p><span class='chat-timestamp'>" + timestamp + " </span> " + name + ": " + message_content + "</p>")


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



  send_chat_message: ->

    #Check if they are sending the message anonymously
    if($('#anon-box').is(":checked"))
      anon = "t"
    else
      anon = "f"

    #build the Payload to be sent to session_channel.rb
    payload =
      content: $('#chat-input').val()
      uid: $('#uid').text()
      utp: $('#utp').text()
      sid: $('#sid').text()
      anon: anon

    #Reset chatbox to nothing
    $('#chat-input').val('')

    #Call method session_channel.rb
    @perform 'send_chat_message', message: payload


  $(document).on 'keypress', '[data-behavior~=chat_send]', (event) ->
    if event.keyCode is 13 # return/enter = send
      App.session.send_chat_message()
      event.preventDefault()

  activate_interactions = ->
    $(".chat-btn").on 'click', (event) ->
      App.session.send_chat_message()
      event.preventDefault()

  $(document).ready(activate_interactions)