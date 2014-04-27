# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->

  $('#send').click ->
    if !$('#message').val()
      return false 

  source = new EventSource('/items/events')
  source.addEventListener 'message', update

update(event) ->
  $('#chat').append(event.data)