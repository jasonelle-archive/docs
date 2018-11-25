const WebSocket = require("ws")
const WebSocketServer = WebSocket.Server
const http = require("http")
const express = require("express")
const app = express()
const port = process.env.PORT || 5000
const jason = require('./app.json')
app.get("/jason", function(req, res) {
  // fill in the agent url with the current server url
  jason.$jason.head.agents.ws.url = req.protocol + '://' + req.get('host');
  res.json(jason)
})
app.use(express.static(__dirname + "/"))
const server = http.createServer(app)
server.listen(port)
console.log("http server listening on %d", port)
const wss = new WebSocketServer({server: server})
const noop = () => {}
console.log("websocket server created")
wss.on('error', function () {});
wss.on('connection', function (ws) {
  ws.on('error', function () {});
  ws.on('message', function(m) {
    wss.clients.forEach(function each(client) {
      if (client.readyState === WebSocket.OPEN) {
        client.send(m);
      }
    });
  });
  setInterval(() => {
    wss.clients.forEach((client) => {
      client.ping(noop)
    });
  }, 1000);
})
