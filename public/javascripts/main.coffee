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
			log.append "<li class=\"jarvis\"><span class=\"user\">Jarvis</span><span class=\"date\">#{ moment(data.date).format 'h:mm a' }</span><span class=\"message\">#{ data.message }</span></li>"
	}

	form.on 'submit', (e) ->
		e.preventDefault()
		text = input.val().trim()
		input.val ''
		if text is '!clear'
			log.empty()
			return
		else if text is '!hide'
			log.find('.you').remove()
			return
		log.append "<li class=\"you\"><span class=\"user\">You</span><span class=\"date\">#{ moment(new Date().toISOString()).format 'h:mm a' }</span><span class=\"message\">#{ text }</span></li>"
		if text isnt ''
			$.ajax {
				type: 'POST'
				url: '/'
				data: {
					message: text
				}
				success: (data) ->
					log.append "<li class=\"jarvis\"><span class=\"user\">Jarvis</span><span class=\"date\">#{ moment(data.date).format 'h:mm a' }</span><span class=\"message\">#{ data.message }</span></li>"
					$('html, body').animate { scrollTop: $(document).height() }, '400'
					input.focus()
			}