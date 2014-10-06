# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

faye = null

$ ->
  return unless $('body').hasClass('rooms')

  return if !window.fayeConfig
  (typeof(faye) == 'undefined' || faye == null) &&
    (faye = new Faye.Client window.fayeConfig.url)

  msg = $('#message')
  form = $('#send-form')

  faye.publish('/in', { message: window.fayeConfig.inMessage })

  msgSub = faye.subscribe window.fayeConfig.messagesChannel, (data) ->
    eval if typeof(data.message) == 'array' then data.message[0] else data.message
  msgSub.errback (error) -> console && console.log 'Msg sub error: ' + error

  onlineSub = faye.subscribe window.fayeConfig.onlineChannel, (data) ->
    id = data.message.split(':')[0]
    status = data.message.split(':')[1]
    opposite = if status == 'online' then 'offline' else 'online'
    $("#player-#{id} .status").removeClass(opposite).addClass(status);

  onlineSub.errback (error) -> console && console.log 'Online sub error: ' + error

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

  $('#chat .message .delete').click ->
    $.ajax {
      type: 'DELETE'
      url: $(this).data('url')
      async: false
    }


$(window).unload ->
  return if !window.fayeConfig
  faye && faye.unsubscribe window.fayeConfig.messagesChannel
