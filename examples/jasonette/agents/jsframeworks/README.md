# Agent ❤️ JavaScript Frameworks

> All your JavaScript framework apps are belong to us.

If you have an existing web app, you already have a Jasonette Agent.

All you need to do is:

1. Add a couple of lines to let your web app communicate with Jasonette as an agent.
2. Then load it as an agent from Jasonette.
3. That's it!

This means, you can actually write a web app that acts as your main website, as well as plug it into Jasonette to make your frontend work like a "backend".

# Examples

## 1. Cell

Uses cell.js library to build a Twitter ticker web app, and Jasonette uses the same web page as an agent.

- The web app: https://jasonette.github.io/agent.jsframeworks/cell/
- The JASON markup that plugs it in as an agent: https://jasonette.github.io/agent.jsframeworks/cell/index.json

## 2. Angular

A sample Angular.js app to add and render values for an angular component.

- The web app: https://jasonette.github.io/agent.jsframeworks/angular/
- The JASON markup that plugs it in as an agent: https://jasonette.github.io/agent.jsframeworks/angular/app.json

## 3. Vue

Super simple Vue.js sample app as seen in vuejs's own tutorial website, but as Jasontte agent.

- The web app: https://jasonette.github.io/agent.jsframeworks/vue/
- The JASON markup that plugs it in as an agent: https://jasonette.github.io/agent.jsframeworks/vue/index.json


# Final Words

Ideally when building agents, it's best to write a pure JavaScript app and don't do anything that touches the DOM, since agents run in the background and users will never see the elements anyway.

However the ability to simply BYOW (bring your own website) and turn it into a "backend" for Jasonette is extremely useful when getting started, and from experience it doesn't affect the performance at all, since most of the agent DOM operations are hidden from user view anyway.
