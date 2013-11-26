var request = require('request');
var util = require('./utility_functions');
var moment = require('moment');

exports.calc = function(message, res) {
	if (message.trim() === '')
		res.send(util.buildMessage('You need to enter an expression to calculate!'));
	message = message.replace(/[^-()\d/*+.]/g, '');
	if (message == '')
		res.send(util.buildMessage('There are no numbers!'));
	res.send(util.buildMessage('The result of ' + message + ' is ' + eval(message) + '.'));
};

exports.date = function(res) {
	res.send(util.buildMessage('It is ' + moment().format('dddd, MMMM Do YYYY, h:mm:ssa.')));
};

exports.weather = function(query, res) {
	var url = 'http://api.worldweatheronline.com/free/v1/weather.ashx?q=' + encodeURIComponent(query) + '&format=json&num_of_days=1&date=today&key=e4zcjce65nyscwr8jqsj8wwr';
	request(url, function (error, response, body) {
		if (!error && response.statusCode === 200) {
			body = JSON.parse(body);
			if (body.data.error)
				res.send(util.buildMessage('Sorry, but weather for that location could not be found.'));
			res.send(util.buildMessage('It is currently ' + body.data.current_condition[0].weatherDesc[0].value.toLowerCase() + ' and ' + body.data.current_condition[0].temp_F + ' degrees Fahrenheit in ' + query + '.'));
		}
		else
			res.send(util.buildMessage('I\'m sorry, but I\'m currently having troubles finding the weather for that location.'));
	});
};

exports.dictionary = function(query, res) {
	// TODO: Add dictionary functionality.
};

exports.help = function(res) {
	var docs = '\
		<ul>\
			<li>!calc expression &rarr; Calculates the expression passed to the command.</li>\
			<li>!date &rarr; Returns the current date and time.</li>\
			<li>!weather location &rarr; Returns the weather for the given location, if the location exists of course.</li>\
			<li>!clear &rarr; Clears the chat log.</li>\
			<li>!hide &rarr; Deletes all commands entered by you from the chat log.</li>\
		</ul>\
	';
	res.send(util.buildMessage(docs));
};