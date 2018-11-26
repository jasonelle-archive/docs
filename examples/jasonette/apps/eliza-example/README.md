# Eliza
This repository contains a JSON express server, which is both the backend AND the frontend for an [Eliza chatbot](https://en.wikipedia.org/wiki/ELIZA) app. 

Point [Jasonette](https://www.jasonette.com) to the root url for this server and it will return a JSON response, which Jasonette will interpret to self-construct into a native app.

# How it works

The core logic is just a typical NLP technique I took from another open source module called `elizabot.js`.

The only part you need to look at is the `main.js`:

1. It starts an [express server](https://expressjs.com/)
2. A Jasonette client makes a GET request to `/`.
3. The server responds by sending back the JSON markup, and the Jasonette client renders accordingly.
4. The markup contains a [footer input](https://jasonette.github.io/documentation/document/#input).
5. When a user presses the `send` button, it [triggers](https://jasonette.github.io/documentation/actions/#triggering-an-action-by-name) the `say` action, which makes a POST request to `/messages`.
6. The server responds to the `POST /messages` request by saving it into local variable and returning the result. (This doesn't use any persistent DB, so the variable only stays on memory and will get reset when the server becomes idle)

# Usage
1. Set up a server using this code.
2. Download [Jasonette](https://www.jasonette.com).
3. Take the root url of your server and play it on Jasonette. [Learn how](https://jasonette.github.io/documentation).

# License

Here's the license for the core Eliza logic.

    elizabot.js v.1.1 - ELIZA JS library (N.Landsteiner 2005)
    Eliza is a mock Rogerian psychotherapist.
    Original program by Joseph Weizenbaum in MAD-SLIP for "Project MAC" at MIT.
    cf: Weizenbaum, Joseph "ELIZA - A Computer Program For the Study of Natural Language
    Communication Between Man and Machine"
        in: Communications of the ACM; Volume 9 , Issue 1 (January 1966): p 36-45.
        JavaScript implementation by Norbert Landsteiner 2005; <http://www.masserk.at>
