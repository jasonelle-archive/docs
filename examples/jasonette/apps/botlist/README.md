# botlist.json
## This repo contains a native iOS app.
You're probably thinking "There's only two JSON files here and that's it, how can this possibly be a native app?"

Well, it's because it's powered by [Jasonette](https://www.jasonette.com), which enables **native apps over HTTP, using JSON**.

The gif you see below is an actual capture of the resulting app

**It's fully native, and served directly from this repo over HTTP.**

[Check out the website](https://www.jasonette.com) to learn how it works.

![botlist gif](https://raw.githubusercontent.com/gliechtenstein/images/master/botlist.gif)

## How botlist.json works

There are two JSON files here: `index.json` and `detail.json`. Each describes a view.

  1. index.json: The home screen
    - [Makes a network request to `botlist.co` website](https://github.com/gliechtenstein/botlist.json/blob/master/index.json#L7).
    - [Parses the response into JSON](https://github.com/gliechtenstein/botlist.json/blob/master/index.json#L21).
    - Renders the result JSON markup into native components.
    - [Transitions to `detail.json` when a user touches an item](https://github.com/gliechtenstein/botlist.json/blob/master/index.json#L54), passing the corresponding url as a parameter.

  2. detail.json: The details screen (bot description)
    - Makes a network request to each bot detail page, using the parameter passed in from `index.json`.
    - Parses the response into JSON.
    - Renders the result JSON markup into native components.

## How to use
1. [Download Jasonette](https://www.jasonette.com).
2. Run `Setup`.
3. When asked for url, enter the [raw JSON url for index.json](https://raw.githubusercontent.com/gliechtenstein/botlist.json/master/index.json).

## Want more?
This is just a small example to demonstrate what kind of apps you can build with nothing but JSON. [Learn more about Jasonette](https://www.jasonette.com)

For questions and support, please use the [Slack chatroom](https://jasonette.herokuapp.com)

[![slack](https://raw.githubusercontent.com/gliechtenstein/images/master/slack.png)](https://jasonette.herokuapp.com)
