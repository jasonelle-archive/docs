var slack = require('slack'),
    Q = require("q"),
    async = require('async');
require('dotenv').config();
var SlackApiToken = process.env.SLACKKEY
var coffee_channel = process.env.COFFEECHANNEL

//for testing slackbottest channel
var testing_channel = process.env.TESTINGCHANNEL

exports.postBrewing = function(user_name, user_id) {
  var botname = 'Coffee Bot'
  var icon_emoji = ":coffeemug:"
  var user_mention = '<@' + user_id + '|' + user_name +'>'
  var twelveMins = 12 * 60 * 1000 // 12 minutes to brew a pot
  var text = user_mention + ' just started brewing a pot :coffee:'
  slack.chat.postMessage({ token:SlackApiToken, channel:coffee_channel, text:text, icon_emoji:icon_emoji, username:botname}, function(err, data) {
    setTimeout(function() {
      var text = 'Coffee is ready. Thanks ' + user_mention + ' for brewing it. :coffee:'
      slack.chat.postMessage({ token:SlackApiToken, channel:coffee_channel, text:text, icon_emoji:icon_emoji, username:botname}, function(err, data) {
      });
    }, twelveMins);
  });
}
