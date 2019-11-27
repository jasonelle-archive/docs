# FireBase Agent

This app (and an agent) uses cell.js framework but you don't have to use cell to build Jasonette agents.

This is just a demonstration. If you're not familiar with cell.js, you can:

1. **Learn www.celljs.org:** it's super simple once you understand the minimum building blocks. Takes prob 10 minutes to learn the whole library.
2. **Or if you just want to learn how:** this is using Jasonette $agents, just take a look at some of the important parts here to learn how it's using $agent.trigger() inside the _update() method. Then you can implement it using vanilla JS or using your favorite JS Framework.

# Try Demo

You can try the web app at [https://jasonette.github.io/agent.firebase](https://jasonette.github.io/agent.firebase)

And the same web app, plugged into Jasonette: [https://jasonette.github.io/agent.firebase/app.json](https://jasonette.github.io/agent.firebase/app.json)

# Brief Overview of what's happening:
    
## A. initializing Firebase

```
firebase.initializeApp(config);
this._ref = firebase.database().ref();
```

## B. Listening to the value change and triggering _update()

```
this._ref.on("value", function(snapshot){
  self._update(snapshot.val()); 
});
```

## C. And finally inside _update(), calling $agent.trigger()

```
$agent.trigger("update", {"items": components.map(function(c) {
  return c.$text
})});
```
