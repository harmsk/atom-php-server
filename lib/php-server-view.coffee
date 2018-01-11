{MessagePanelView, PlainMessageView, LineMessageView} = require 'atom-message-panel'

module.exports =
  class PhpServerView
    constructor: ->
      @panel = new MessagePanelView(title: 'PHP Server Console')
      @body = @panel.body

      @dock = {
        element: @body[0],
        getTitle: () => 'PHP Server Console',
        getURI: () => 'atom://php-server/console',
        getDefaultLocation: () => 'bottom'
      }

    show: ->
      atom.workspace.open(@dock);

    hide: ->
      atom.workspace.hide(@dock);

    toggle: ->
      atom.workspace.toggle(@dock);

    addMessage: (lines, logLevel, raw = false) ->
      for text in lines.split "\n"
        linematch = /^(.+)in ([a-z\\\/\.\-_]+) on line ([0-9]+)$/i
        match = text.match linematch
        if match
          @panel.add(new LineMessageView(
            line: match[3]
            file: match[2]
            message: match[1]
            className: 'text-danger'
          ))
        else
          if(atom.config.get('php-server.accessLog'))
            @panel.add(new PlainMessageView(
              message: text
              raw: raw
            ))
        @show() if logLevel == 'all'
        @body.scrollToBottom()

    addSuccess: (lines, raw = false) ->
      @panel.add(new PlainMessageView(
        message: lines
        className: 'text-success',
        raw: raw
      ))

    addError: (lines, raw = false) ->
      @panel.add(new PlainMessageView(
        message: lines
        className: 'text-error'
        raw: false
      ))

    clear: ->
      @panel.clear()
