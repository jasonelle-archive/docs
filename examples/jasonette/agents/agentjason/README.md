# Jasonette Agent Examples

Agents are like microservices that live on a mobile frontend.

This repo includes some examples of Jasonette APIs

You can start by opening the root [index.json](https://jasonette.github.io/AgentJason/index.json) from Jasonette.

Here's a brief overview:

1. trigger: Demonstrates `$agent.trigger`.
2. request: Demonstrates `$agent.request` and `$agent.response`.
3. href: Demonstrates `$agent.href`
4. inject: Demonstrates `$agent.inject`
  - Loads an agent that loads https://news.ycombinator.com
  - Injects `inject.js` into the agent
  - Executes a function called `fetch`, which only parses the DOM and returns an array using `$agent.response`
  - The `index.json` then renders the returned result, just like it would with any other actions such as `$network.request`
