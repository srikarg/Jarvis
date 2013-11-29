request = require 'request'
util = require './utility_functions'
help = require './help'
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
			res.send util.buildMessage 'I\'m sorry, but I\'m currently having trouble finding the weather for that location.'

exports.dictionary = (query, res) ->
	# TODO: Add dictionary functionality.

exports.xkcd = (query, res) ->
	if query is ''
		url = 'http://xkcd.com/info.0.json'
		request url, (error, response, body) ->
			if not error and response.statusCode is 200
				body = JSON.parse body
				res.send util.buildMessage "<div class=\"xkcd\"><p>Title of comic: #{ body.safe_title }</p><img src=\"#{ body.img }\" /></div>"
			else
				res.send util.buildMessage 'Sorry, but the most recent XKCD comic could not be retrieved.'
	else
		if not isNaN query # If the query is a number...
			url = "http://xkcd.com/#{ query }/info.0.json"
			request url, (error, response, body) ->
				if not error and response.statusCode is 200
					body = JSON.parse body
					res.send util.buildMessage "<div class=\"xkcd\"><p>Title of comic: #{ body.safe_title }</p><img src=\"#{ body.img }\" /></div>"
				else
					res.send util.buildMessage 'Sorry, but the comic with the given number was not found.'
		else
			res.send util.buildMessage 'Please enter a valid value for the comic number!'

exports.help = (res) ->
	docs = help.getDocs()
	html = "<ul>"
	for key, value of docs
		html += "<li>!#{ key } &rarr; #{ value }</li>"
	html += "</ul>"
	res.send util.buildMessage html