logMessage = (message, date, user, log) ->
    log.append """
            <li>
              <span class="user">#{ if user is "jarvis" then "Jarvis" else "You" }</span>
              <span class="date">#{ moment(date).format 'h:mm a' }</span>
              <span class="message">#{ message }</span>
            </li>
            """
    $('html, body').animate { scrollTop: $(document).height() }, '400'

$ ->
    log = $ '.log ul'
    input = $ '.input'
    form = $ '.form'
    input.focus()

    $.ajax {
        type: 'POST'
        url: '/'
        data: {
            welcome: true
        }
        success: (data) ->
            logMessage data.message, data.date, 'jarvis', log
    }

    form.on 'submit', (e) ->
        e.preventDefault()
        text = input.val().trim()
        input.val ''
        logMessage text, new Date().toISOString(), 'you', log
        if text is '!clear'
            log.empty()
            return
        else if text is '!hide'
            log.find('span.user').each () ->
                if $(this).text().trim() is 'You'
                    $(this).parent('li').remove()
            return
        else if text is '!date'
            logMessage "It is #{ moment().format 'dddd, MMMM Do YYYY, h:mm:ssa.' }", new Date().toISOString(), 'jarvis', log
            return
        if text isnt ''
            $.ajax {
                type: 'POST'
                url: '/'
                data: {
                    message: text
                }
                success: (data) ->
                    logMessage data.message, data.date, 'jarvis', log
                    input.focus()
            }