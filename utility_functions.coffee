exports.buildMessage = (message) ->
	return {
		date: new Date().toISOString()
		message: message
	}

exports.random = (items) ->
	return items[Math.floor(Math.random() * items.length)]