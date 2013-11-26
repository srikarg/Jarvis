var express = require('express');
var app = express();
var commands = require('./commands');
var util = require('./utility_functions');
var http = require('http');
var path = require('path');
var port = process.env.PORT || 3000;

console.log('Server running on port: ' + port + '.');

app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'jade');
app.use(express.logger('dev'));
app.use(express.json());
app.use(express.urlencoded());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.static(path.join(__dirname, 'public')));
app.use(express.favicon(path.join(__dirname, 'public/images/favicon.ico')));

if ('development' == app.get('env')) {
	app.use(express.errorHandler());
}

app.get('/', function(req, res) {
	res.render('index');
});

app.post('/', function(req, res) {
	if (req.body.welcome) {
		res.send(util.buildMessage('Welcome master! Enter some commands below to get started! Don\'t know any commands? Type "!help"!'));
		return;
	}

	var post = req.body.message;

	if (post.indexOf('!') == -1) {
		post = post.toLowerCase();
		if (post.indexOf('thank') !== -1) {
			res.send(util.buildMessage('No need to thank me. I was built to serve you master.'));
			return;
		}

		if (post.indexOf('hate') !== -1) {
			res.send(util.buildMessage('No need to hate me. I\'m just here to serve you.'));
			return;
		}

		res.send(util.buildMessage('Please enter a command master. Enter "!help" if you want to see a list of commands.'));
		return;
	}

	var triggerLength = post.split(' ')[0].length;
	var trigger = post.substring(0, triggerLength);
	var message = post.substring(triggerLength + 1);
	var result = '';

	switch(trigger) {
		case '!calc':
			commands.calc(message, res);
			break;
		case '!date':
			commands.date(res);
			break;
		case '!weather':
			commands.weather(message, res);
			break;
		case '!help':
			commands.help(res);
			break;
		case '!dict':
			commands.dict(message, res);
			break;
		default:
			res.send(util.buildMessage('I\'m sorry, but that command was not found! Enter "!help" if you want to see a list of commands.'));
			break;
	}
});

app.listen(port);