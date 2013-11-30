request = require 'request'
util = require './utility_functions'
help = require './help'
moment = require 'moment'

exports.calc = (query, res) ->
	if query is ''
		res.send util.buildMessage 'You need to enter an expression to calculate!'

	query = query.replace /[^-()\d/*+.]/g, ''

	if query is ''
		res.send util.buildMessage 'There are no numbers!'
	res.send util.buildMessage "The result of #{ query } is #{ eval query }"

exports.date = (res) ->
	res.send util.buildMessage "It is #{ moment().format 'dddd, MMMM Do YYYY, h:mm:ssa.' }"

exports.weather = (query, res) ->
	if query is ''
		res.send util.buildMessage 'I need a location to find the weather for master!'
		return
	url = "http://api.worldweatheronline.com/free/v1/weather.ashx?q=#{ encodeURIComponent query }&format=json&num_of_days=1&date=today&key=e4zcjce65nyscwr8jqsj8wwr"
	request url, (error, response, body) ->
		if not error and response.statusCode is 200
			body = JSON.parse body
			if body.data.error
				res.send util.buildMessage 'Sorry, but weather for that location could not be found.'
				return
			res.send util.buildMessage "It is currently #{ body.data.current_condition[0].weatherDesc[0].value.toLowerCase() } and #{ body.data.current_condition[0].temp_F } degrees Fahrenheit in #{ query }."
		else
			res.send util.buildMessage 'I\'m sorry, but I\'m currently having trouble finding the weather for that location.'

exports.dict = (query, res) ->
	if query is ''
		res.send util.buildMessage 'I need a word to find the definition for master!'
		return
	url = "http://api.duckduckgo.com/?q=define+#{ encodeURIComponent query }&format=json"
	request url, (error, response, body) ->
		if not error and response.statusCode is 200
			body = JSON.parse body
			if typeof body.Definition isnt 'undefined' and body.Definition isnt ''
				definition = body.Definition.slice(body.Definition.indexOf(': ') + 1).replace(/'''/g, '"').trim()
				res.send util.buildMessage "<div class=\"dictionary\"><span class=\"bold\">#{ query }</span>: <span class=\"italics\">#{ definition }</span></div>"
			else
				res.send util.buildMessage "I'm sorry, but the definition for <span class=\"bold\">#{ query }</span> could not be found!"
		else
			res.send util.buildMessage "I'm sorry, but I'm currently having trouble finding the definition for <span class=\"bold\">#{ query }</span>."

exports.xkcd = (query, res) ->
	if query is ''
		url = 'http://xkcd.com/info.0.json'
		request url, (error, response, body) ->
			if not error and response.statusCode is 200
				body = JSON.parse body
				res.send util.buildMessage "<div class=\"xkcd\"><p><a href=\"http://xkcd.com/#{ body.num }/\">#{ body.title }</a></p><img src=\"#{ body.img }\" /></div>"
			else
				res.send util.buildMessage 'Sorry, but the most recent XKCD comic could not be retrieved.'
	else
		if not isNaN query
			url = "http://xkcd.com/#{ query }/info.0.json"
			request url, (error, response, body) ->
				if not error and response.statusCode is 200
					body = JSON.parse body
					res.send util.buildMessage "<div class=\"xkcd\"><p><a href=\"http://xkcd.com/#{ body.num }/\">#{ body.title }</a></p><img src=\"#{ body.img }\" /></div>"
				else
					res.send util.buildMessage 'Sorry, but the comic with the given number was not found.'
		else
			res.send util.buildMessage 'Please enter a valid value for the comic number!'

exports.help = (res) ->
	docs = help.getDocs()
	html = "<ul class=\"text-align-left\">"
	for key, value of docs
		html += "<li>!#{ key } &rarr; #{ value }</li>"
	html += "</ul>"
	res.send util.buildMessage html