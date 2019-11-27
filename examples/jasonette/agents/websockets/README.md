# Websocket

This example contains:

1. Websockets Web Client: [index.html](./index.html)
2. Websockets Server: [app.js](./app.js)
3. Jasonette markup that uses `index.html` as an agent: [app.json](./app.json)

# Try it out

Since this example requires a server, you can try the deployed versiont at [http://wsjason.herokuapp.com/](http://wsjason.herokuapp.com/).

First check that the websocket chat works between multiple different browsers.

Then open [app.json](http://wsjason.herokuapp.com/app.json) on Jasonette to make it run as a Jasonette native app.

# To try on your own server

Open app.json and just change the `$jason.head.agents.ws.url` to your agent HTML URL.
