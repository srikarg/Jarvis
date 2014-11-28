// Generated by CoffeeScript 1.8.0
(function() {
  var logMessage;

  logMessage = function(message, date, user, log) {
    log.append("<li>\n  <span class=\"user\">" + (user === "jarvis" ? "Jarvis" : "You") + "</span>\n  <span class=\"date\">" + (moment(date).format('h:mm a')) + "</span>\n  <span class=\"message\">" + message + "</span>\n</li>");
    return $('html, body').animate({
      scrollTop: $(document).height()
    }, '400');
  };

  $(function() {
    var form, input, log;
    log = $('.log ul');
    input = $('.input');
    form = $('.form');
    input.focus();
    $.ajax({
      type: 'POST',
      url: '/',
      data: {
        welcome: true
      },
      success: function(data) {
        return logMessage(data.message, data.date, 'jarvis', log);
      }
    });
    return form.on('submit', function(e) {
      var text;
      e.preventDefault();
      text = input.val().trim();
      input.val('');
      logMessage(text, new Date().toISOString(), 'you', log);
      if (text === '!clear') {
        log.empty();
        return;
      } else if (text === '!hide') {
        log.find('span.user').each(function() {
          if ($(this).text().trim() === 'You') {
            return $(this).parent('li').remove();
          }
        });
        return;
      } else if (text === '!date') {
        logMessage("It is " + (moment().format('dddd, MMMM Do YYYY, h:mm:ssa.')), new Date().toISOString(), 'jarvis', log);
        return;
      }
      if (text !== '') {
        return $.ajax({
          type: 'POST',
          url: '/',
          data: {
            message: text
          },
          success: function(data) {
            logMessage(data.message, data.date, 'jarvis', log);
            return input.focus();
          }
        });
      }
    });
  });

}).call(this);