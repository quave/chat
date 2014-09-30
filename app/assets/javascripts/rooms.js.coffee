# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

deleteMessage = (url) ->
  $.ajax {
    type: 'DELETE'
    url: url
    async: false
  }

faye = null

$ ->
  return if !window.fayeConfig
  (typeof(faye) == 'undefined' || faye == null) &&
    (faye = new Faye.Client window.fayeConfig.url)
  #Faye.Transport.WebSocket.isUsable = (_,url,c) -> c false

  msg = $('#message')
  form = $('#send-form')

  subscription = faye.subscribe window.fayeConfig.messagesChannel, (data) ->
    eval if typeof(data.message) == 'array' then data.message[0] else data.message

  subscription.errback (error) -> console && console.log error
  faye.publish('/in', { message: window.fayeConfig.inMessage })

  $(document).scrollTop($(document).height());

  msg.keydown (e) ->
    return if $(this).is ':disabled'

    if e.keyCode == 13 && e.ctrlKey
      form.submit()

  form.on 'ajax:beforeSend.rails', ->
    return false if $.trim(msg.val()) == ''
    msg.attr 'disabled', 'disabled'

  $('#players li .char').click ->
    text = msg.val()
    name = $(this).text()
    text && (text += ' ')
    tmp = text + name + ', '
    msg.focus().val('').val(tmp)

  $('#chat .message .delete').click -> deleteMessage $(this).data('url')

$(window).unload ->
  return if !window.fayeConfig
  faye && faye.unsubscribe window.fayeConfig.messagesChannel
