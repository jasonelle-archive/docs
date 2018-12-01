# Coffee App
This is a server that will generate [Jasonette](http://jasonette.com/) valid Jason for IOS or Android (or the respective Jason apps). 

The Apps show the faces of the slack users in the channel specified in the `.env` file. If a face is pressed, a slackbot will update the channel saying coffee is brewing, and 12 minutes later that coffee is ready. 

## Using it
### Development
You'll need node installed and npm
Run `npm install` inside of the repo directory.
Create a `.env` file in the root of the directory with the following items:
```
SLACKKEY=<your-slack-token>
COFFEECHANNEL=<The coffee channel id>
TESTINGCHANNEL=<a public channel id for testing>
```

An easy way to find the channel identifiers is to use [this page](https://api.slack.com/methods/channels.list/test) and search for the channel names and copy the identifiers. 

Run the server with 'node server.js'.

And finally either build an [Android](https://jasonette.github.io/documentation/android/) or [IOS](https://jasonette.github.io/documentation/ios/) app (following the directions here), or point the relevant Jason app ([ios](https://itunes.apple.com/us/app/jason./id1095557868?mt=8_), [android](https://play.google.com/store/apps/details?id=com.jasonette.seed)) at `localhost:3000/jsonette.json`
