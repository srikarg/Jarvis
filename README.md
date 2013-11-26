# Jarvis

## What is it?

Jarvis is a Node.js bot that strives to emulates the functionality of J.A.R.V.I.S. from the Iron Man movie series. Some of its commands can be found in commands.js.

## How can I install Jarvis?

Clone this repository and then run `npm install` to install the server's dependencies. Finally, run `node app.js` to fire up the server and navigate your web browser to `localhost:3000`.

## How can I help?

1. First, enter your new command into `commands.js`. The data that the user passed to the command can be accessed by the `query` variable.

```
exports.myAwesomeCommand = function(query, res) {
	// Do something awesome.
	// 
}
```

2. Next, add you command's trigger, prefixed by an exclamation point, into the `switch` block in `app.js`. You will need to call the function you just created in the previous step. Also, note that the data the user passed to the command is the `message` parameter for the command's function. The `res` allows the function to send its output back to the user.

```
case '!yourAwesomeCommandTrigger':
	commands.myAwesomeCommand(message, res);
	break;
```