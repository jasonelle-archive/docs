# botlist.json
## This repo contains a native iOS app.
You're probably thinking "There's only two JSON files here and that's it, how can this possibly be a native app?"

Well, it's because it's powered by [Jasonette](https://www.jasonelle.com), which enables **native apps over HTTP, using JSON**.

The gif you see below is an actual capture of the resulting app

**It's fully native, and served directly from this repo over HTTP.**

[Check out the website](https://www.jasonelle.com) to learn how it works.

![botlist gif](https://raw.githubusercontent.com/gliechtenstein/images/master/botlist.gif)

## How botlist.json works

There are two JSON files here: `index.json` and `detail.json`. Each describes a view.

  1. index.json: The home screen
    - [Makes a network request to `botlist.co` website](./index.json#L7).
    - [Parses the response into JSON](./index.json#L21).
    - Renders the result JSON markup into native components.
    - [Transitions to `detail.json` when a user touches an item](./index.json#L54), passing the corresponding url as a parameter.

  2. detail.json: The details screen (bot description)
    - Makes a network request to each bot detail page, using the parameter passed in from `index.json`.
    - Parses the response into JSON.
    - Renders the result JSON markup into native components.

## How to use
1. [Download Jasonette](https://www.jasonelle.com).
2. When asked for url, enter the [raw JSON url for index.json](https://raw.githubusercontent.com/jasonelle/docs/develop/examples/jasonette/apps/botlist/index.json).
