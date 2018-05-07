# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

App.session = App.cable.subscriptions.create "SessionChannel",
  connected: ->
# Called when the subscription is ready for use on the server

  disconnected: ->
# Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
    payload = data['message']
    message_content = payload['content']

    $('#chat-messages').append("<p>" + message_content + "</p>")



  speak: (message) ->
    @perform 'speak', message: message


  $(document).on 'keypress', '[data-behavior~=room_speaker]', (event) ->
    if event.keyCode is 13 # return/enter = send
      payload =
        content: event.target.value
        uid: $('#uid').text()
        utp: $('#utp').text()
        sid: $('#sid').text()

      App.session.speak payload
      event.target.value = ''
      event.preventDefault()