exports.buildMessage = function(message) {
	return {
		date: new Date().toISOString(),
		message: message
	};
};