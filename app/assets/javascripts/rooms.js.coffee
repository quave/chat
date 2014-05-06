# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  faye = new Faye.Client window.fayeUrl
  faye.setHeader 'Access-Control-Allow-Origin', '*'
  Faye.Transport.WebSocket.isUsable = (_,url,c) -> c false
  subscription = faye.subscribe window.fayeMessagesChannel, (data) -> eval data
  subscription.errback (error) -> console && console.log error

  msg = $('#message')
  form = $('#send-form')

  $('html, body').animate { scrollTop: $(document).height() }, 'slow'

  msg.keydown (e) ->
    return if $(this).is ':disabled'

    if e.keyCode == 13 && e.ctrlKey
      form.submit()

  form.on 'ajax:beforeSend.rails', ->
    return false if $.trim(msg.val()) == ''
    msg.attr 'disabled', 'disabled'

  $('#players li').click -> 
    text = $(message).val()
    name = $(this).text()
    text && (text += ' ')

    $(message).val text + name + ', '
