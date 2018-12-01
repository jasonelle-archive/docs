var slack = require('slack'),
    Q = require("q"),
    async = require('async');
require('dotenv').config();

var SlackApiToken = process.env.SLACKKEY
var coffee_channel = process.env.COFFEECHANNEL

//for testing slackbottest channel
var testing_channel = process.env.TESTINGCHANNEL

exports.getJson = function(root_url) {
  return Q.Promise(function(resolve) {
    getChannelInfo()
    .then(function (result) {
      getmemberInfo(result)
        .then(function(members){
          members = filterMembers(members);
          var returnJson = writeJson(members, root_url);
          resolve(returnJson);
      });
    });
  })
}

getChannelInfo = function() {
  return Q.Promise(function(resolve) {
    members = [];
    slack.channels.info({ token:SlackApiToken, channel:coffee_channel}, function(err, data) {
      resolve(data.channel.members);
    });
  });
}

filterMembers = function(members) {
  filteredMembers = []
  for (var i=0;i<members.length; i++) {
    if (!members[i].user.deleted && !members[i].user.is_bot) {
        filteredMembers.push(members[i].user)
    }
  }
  return filteredMembers;
}

getmemberInfo = function(members) {
  return Q.Promise(function(resolve) {
    membersResult = [];
    for (var i = 0; i < members.length; i++) {
      slack.users.info({token:SlackApiToken, user:members[i]}, function(err, data){
        membersResult.push(data);
        if (membersResult.length  == members.length) {
          resolve(membersResult);
        };
      });
    }
  });
};

writeJson = function(members, root_url) {
  var jsonout = {
    "$jason": {
      "head": {
        "title": "Coffee Time",
        "actions": {
          "$pull": {
            "type": "$reload"
          }
        },
        "data": {
          "members": members
        },
        "templates": {
          "body": {
            "header": {
              "title": "☕ Coffee ☕"
            },
            "footer": {
            },
            "sections": [
              {
                "header": {
                  "type": "label",
                  "text": "Tap if you're brewing",
                  "style": {
                    "font": "HelveticaNeue-Bold",
                    "size": "12"
                  }
                },
                "items": {
                  "{{#each members}}": {
                    "type": "horizontal",
                    "style": {
                      "spacing": "10",
                      "align": "center"
                    },
                    "action": {
                      "type": "$network.request",
                      "options": {
                        "url": root_url + "/submit.json",
                        "method": "POST",
                        "data": {
                          "user_name": "{{name}}",
                          "user_id":"{{id}}"
                        }
                      },
                      "success": {
                        "type": "$util.toast",
                        "options": {
                            "text": "Thanks {{profile.first_name}}! Watch the #coffee channel for when it's ready.",
                            "type": "success"
                        }
                      }
                    },
                    "components": [
                      {
                        "type": "image",
                        "url": "{{profile.image_192}}",
                        "style": {
                          "height": "80",
                          "corner_radius": "5"
                        }
                      },
                      {
                        "type": "label",
                        "text": "{{real_name}}",
                        "style": {
                          "font": "HelveticaNeue-Bold",
                          "size": "20"
                        }
                      }
                    ]
                  }
                }
              }
            ]
          }
        }
      }
    }
  }
  return jsonout;
}