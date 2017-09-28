{$, View} = require 'atom-space-pen-views'
{MessagePanelView, PlainMessageView, LineMessageView} = require 'atom-message-panel'

module.exports =
  class PhpServerView extends MessagePanelView
    addMessage: (lines, logLevel) ->
      for text in lines.split "\n"
        linematch = /^(.+)in ([a-z\\\/\.\-_]+) on line ([0-9]+)$/i
        match = text.match linematch
        if match
          @add(new LineMessageView(
            line: match[3]
            file: match[2]
            message: match[1]
            className: 'text-danger'
          ))
        else
          if(atom.config.get('php-server.accessLog'))
            @add(new PlainMessageView(
              message: text
            ))
        @toggle() if !@body.isVisible() && logLevel == 'all'
        @body.scrollToBottom()
    addSuccess: (lines) ->
      @add(new PlainMessageView(
        message: lines
        className: 'text-success'
      ))
    addError: (lines) ->
      @add(new PlainMessageView(
        message: lines
        className: 'text-error'
      ))

    hide: ->
      @toggle() if @body.isVisible()
