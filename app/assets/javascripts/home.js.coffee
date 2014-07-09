# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
    $tagLine = $ '.tag-line'

    # Ideally this array would come from somewhere in the server.
    tagLines = [
        'Schedule a meeting for next tuesday.',
        'Send Alice an e-mail.',
        'Invite Bob to my birth-day party.',
        'Text mom I love her.'
        'Let\'s play chess.',
        'Make me a sandwich.'
    ]

    i = 0

    tickHandler = ->
        $tagLine.text tagLines[i++]

        i = 0 if i >= tagLines.length

    # 5 seconds.
    lapse = 5000

    setInterval tickHandler, lapse