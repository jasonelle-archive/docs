/**
 * Module dependencies
 */

var express = require('express'),
  bodyParser = require('body-parser'), 
  methodOverride = require('method-override'),
  errorHandler = require('errorhandler'),
  http = require('http'),
  path = require('path'),
  jsonette = require('./modules/jsonette.js'),
  slackPost = require('./modules/slackPosting.js');

require('dotenv').config();

var app = module.exports = express();

/**
 * Configuration
 */

// all environments
app.set('port', process.env.PORT || 3000);
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(methodOverride());

var env = process.env.NODE_ENV || 'development';

// development only
// if (env === 'development') {
//   app.use(express.errorHandler());
// }

// production only
if (env === 'production') {
  // TODO
}


app.get('/', function(req, res) {
  res.sendfile(__dirname + "/public/js/partials/index.html");
});

app.get('/bower_components/*', function(req, res) {
  res.sendfile(__dirname + req.originalUrl);
});

app.get('/node_modules/*', function(req, res) {
  res.sendfile(__dirname + req.originalUrl);
});

app.get('/jsonette.json', function(req, res) {
  console.log("new user");
  var root_url = req.protocol + '://' + req.get('host'); 
  jsonette.getJson(root_url)
  .then(function(result){ 
    res.json(result);
  });
});

app.post('/submit.json', function(req, res) {
  console.log(req.body.user_name);
  slackPost.postBrewing(req.body.user_name, req.body.user_id);
  res.json("success");
})

app.get('/public/*', function(req, res) {
  res.sendfile(__dirname + req.originalUrl);
});
/**
 * Start Server
 */

http.createServer(app).listen(app.get('port'), function () {
  console.log('Express server listening on port ' + app.get('port'));
});