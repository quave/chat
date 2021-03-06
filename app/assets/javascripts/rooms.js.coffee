# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

faye = null

$ ->
  return unless $('body').hasClass('rooms')
  msg = $('#message')
  form = $('#send-form')

  initMsgInput(msg)

  return if !window.fayeConfig
  (typeof(faye) == 'undefined' || faye == null) &&
    (faye = new Faye.Client window.fayeConfig.url)

  testWs = new WebSocket(window.fayeConfig.url.replace(/^http/, 'ws'))
  testWs.onerror = ->
    faye.disable 'websocket'
    Faye.Transport.WebSocket.isUsable = (_,url,c) -> c false
    continueInit()
  testWs.onopen = ->
    continueInit()

  continueInit = ->

    faye.on 'transport:up', ->
      console.log 'up', arguments, this
      $.ajax {
        url: window.fayeConfig.onlineUrl
        type: 'POST'
        data: {
          id: faye._clientId
          user_id: window.fayeConfig.userId
          room_id: window.fayeConfig.roomId
        }
        success: ->
          console.log('Online send', arguments)
      }

    faye.on 'transport:down', ->
      console.log 'down', arguments, this

    extLogger = {
      incoming: (message, callback) ->
        console.log('incoming', message)
        callback(message)
      outgoing: (message, callback) ->
        console.log('outgoing', message)
        callback(message)
    }

    faye.addExtension(extLogger)

    msgSub = faye.subscribe window.fayeConfig.messagesChannel, (data) ->
      eval if typeof(data.message) == 'array' then data.message[0] else data.message
    msgSub.errback (error) -> console && console.log 'Msg sub error: ' + error

    onlineSub = faye.subscribe window.fayeConfig.onlineChannel, (data) ->
      id = data.message.split(':')[0]
      status = data.message.split(':')[1]
      opposite = if status == 'online' then 'offline' else 'online'
      $("#player-#{id} .status").removeClass(opposite).addClass(status)

    onlineSub.errback (error) -> console && console.log 'Online sub error: ' + error

    $(document).scrollTop($(document).height())

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

initMsgInput = (input) ->
  getCallback = (roll) ->
    (e) ->
      # Replace selection with some drinks
      selected = e.getSelection()
      content = e.getContent()

      # Give random drink
      chunk = '\\roll d' + roll

      # transform selection and set the cursor into chunked text
      if selected.length
        e.replaceSelection(chunk)
        cursor = selected.start
      else
        e.setContent(chunk + ' ' + content)
        cursor = 0

      # Set the cursor
      e.setSelection cursor, cursor+chunk.length

  buttons = []
  for n in [4, 6, 8, 10, 20, 100]
    title = 'd' + n
    buttons.push({
      name: title
      toggle: false
      title: title
      btnText: title
      callback: getCallback(n)
    })

  input.markdown {
    autofocus: true
    additionalButtons: [[{ name: 'groupRolls', cssClass:'rolls',  data: buttons }]]
  }