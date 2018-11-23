# kitty.json
## This repo contains a native iOS app.
You're probably thinking "There's only two JSON files here and that's it, how can this possibly be a native app?"

Well, it's because it's powered by [Jasonette](https://www.jasonette.com), which enables **native apps over HTTP, using JSON**.

The gif you see below is an actual capture of the resulting app

**It's fully native, and served directly from this repo over HTTP.**

[Check out the website](https://www.jasonette.com) to learn how it works.

![kitty gif](https://raw.githubusercontent.com/gliechtenstein/images/master/kitty.gif)

## How kitty.json works

There are three JSON files here: `index.json`, `popular.json`, and `detail.json`. Each describes a view.

  1. popular.json: The second tab ("sorted by rank")
    - [Makes a network request to `producthunt.com` website](https://github.com/gliechtenstein/kitty.json/blob/master/index.json#L20).
    - [Parses the response into JSON](https://github.com/gliechtenstein/kitty.json/blob/master/index.json#L30).
    - Renders the result JSON markup into native components.
    - [Transitions to `detail.json` when a user touches an item](https://github.com/gliechtenstein/kitty.json/blob/master/index.json#L88), passing the corresponding url as a parameter.

  2. index.json: The home tab. Works the same way as popular.json, but displays the [result sorted by time](https://github.com/gliechtenstein/kitty.json/blob/master/index.json#L72).

  3. detail.json: The details screen (product details page)
    - Makes a network request to each detail page, using the parameter passed in from `index.json` and `popular.json`.
    - Parses the response into JSON.
    - Renders the result JSON markup into native components.

## How to use
1. [Download Jasonette](https://www.jasonette.com).
2. Run `Setup`.
3. When asked for url, enter the [raw JSON url for index.json](https://raw.githubusercontent.com/gliechtenstein/kitty.json/master/index.json).

## Want more?
This is just a small example to demonstrate what kind of apps you can build with nothing but JSON. [Learn more about Jasonette](https://www.jasonette.com)

For questions and support, please use the [Slack chatroom](https://jasonette.now.sh/)

[![slack](https://raw.githubusercontent.com/gliechtenstein/images/master/slack.png)](https://jasonette.now.sh/)
