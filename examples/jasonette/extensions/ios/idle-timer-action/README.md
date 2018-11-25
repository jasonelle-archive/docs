# JasonIdleTimerAction
Jasonette Action for the Idle Timer Property (iOS).

## Idle Timer

[Apple Docs](https://developer.apple.com/reference/uikit/uiapplication/1623070-idletimerdisabled?language=objc)

A Boolean value that controls whether the idle timer is disabled for the app.

The default value of this property is NO. When most apps have no touches as user input for a short period, the system puts the device into a "sleep” state where the screen dims. This is done for the purposes of conserving power. However, apps that don't have user input except for the accelerometer—games, for instance—can, by setting this property to YES, disable the “idle timer” to avert system sleep.

You should set this property only if necessary and should be sure to reset it to NO when the need no longer exists. Most apps should let the system turn off the screen when the idle timer elapses. This includes audio apps. With appropriate use of Audio Session Services, playback and recording proceed uninterrupted when the screen turns off. The only apps that should disable the idle timer are mapping apps, games, or programs where the app needs to continue displaying content when user interaction is minimal.

## Usage

### $idle.enable
Executes `[[UIApplication sharedApplication] setIdleTimerDisabled:NO];`

### $idle.disable
Executes `[[UIApplication sharedApplication] setIdleTimerDisabled:YES];`

Made with <i class="fa fa-heart">&#9829;</i> by <a href="http://ninjas.cl" target="_blank">Ninjas.cl</a>.