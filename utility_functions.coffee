exports.buildMessage = (message) ->
	return {
		date: new Date().toISOString()
		message: message
	}