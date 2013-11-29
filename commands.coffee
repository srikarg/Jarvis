request = require 'request'
util = require './utility_functions'
moment = require 'moment'

exports.calc = (message, res) ->
	if message.trim() is ''
		res.send util.buildMessage 'You need to enter an expression to calculate!'

	message = message.replace /[^-()\d/*+.]/g, ''

	if message is ''
		res.send util.buildMessage 'There are no numbers!'
	res.send util.buildMessage "The result of #{ message } is #{ eval message }"

exports.date = (res) ->
	res.send util.buildMessage "It is #{ moment().format 'dddd, MMMM Do YYYY, h:mm:ssa.' }"

exports.weather = (query, res) ->
	url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{ encodeURIComponent query }&format=json&num_of_days=1&date=today&key=e4zcjce65nyscwr8jqsj8wwr"
	request url, (error, response, body) ->
		if not error and response.statusCode is 200
			body = JSON.parse body
			if body.data.error
				res.send util.buildMessage 'Sorry, but weather for that location could not be found.'
			res.send util.buildMessage "It is currently #{ body.data.current_condition[0].weatherDesc[0].value.toLowerCase() } and #{ body.data.current_condition[0].temp_F } degrees Fahrenheit in #{ query }."
		else
			res.send util.buildMessage 'I\'m sorry, but I\'m currently having troubles finding the weather for that location.'

exports.dictionary = (query, res) ->
	# TODO: Add dictionary functionality.

exports.help = (res) ->
	docs =  """
			<ul>
				<li>!calc expression &rarr; Calculates the expression passed to the command.</li>
				<li>!date &rarr; Returns the current date and time.</li>
				<li>!weather location &rarr; Returns the weather for the given location, if the location exists of course.</li>
				<li>!clear &rarr; Clears the chat log.</li>
				<li>!hide &rarr; Deletes all commands entered by you from the chat log.</li>
			</ul>
			"""
	res.send util.buildMessage docs