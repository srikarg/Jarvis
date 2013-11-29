express = require 'express'
commands = require './commands'
util = require './utility_functions'
http = require 'http'
path = require 'path'
port = process.env.PORT or 3000
app = express()

console.log "Server running on port #{ port }."

app.set 'views', path.join(__dirname, 'views')
app.set 'view engine', 'jade'
app.use express.logger 'dev'
app.use express.json()
app.use express.urlencoded()
app.use express.methodOverride()
app.use app.router
app.use express.static(path.join __dirname, 'public')
app.use express.favicon(path.join __dirname, 'public/images/favicon.ico')

if app.get 'env' is 'development'
	app.use express.errorHandler()

app.get '/', (req, res) ->
	res.render 'index'

app.post '/', (req, res) ->
	if req.body.welcome
		res.send util.buildMessage 'Welcome master! Enter some commands below to get started! Don\'t know any commands? Type "!help"!'
		return

	post = req.body.message

	if post.indexOf('!') is -1
		post = post.toLowerCase()

		if post.indexOf('thank') isnt -1
			res.send util.buildMessage 'No need to thank me. I was built to serve you master.'
			return

		if post.indexOf('hate') isnt -1
			res.send util.buildMessage 'No need to hate me. I\'m just here to serve you.'
			return

		res.send util.buildMessage 'Please enter a command master. Enter "!help" if you want to see a list of commands.'
		return

	triggerLength = post.split(' ')[0].length
	trigger = post.substring 0, triggerLength
	message = post.substring triggerLength + 1

	switch trigger
		when '!calc' then commands.calc message, res
		when '!date' then commands.date res
		when '!weather' then commands.weather message, res
		when '!help' then commands.help res
		when '!dict' then commands.dict message, res
		else res.send util.buildMessage 'I\'m sorry, but that command was not found! Enter "!help" if you want to see a list of commands.'

app.listen port