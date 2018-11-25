# JasonSEGAnalyticsAction for Android

Jasonette extension for integrating [segment.io](https://www.segment.io)

See the iOS version [here](https://github.com/gliechtenstein/JasonSEGAnalyticsAction)

# Setup

1. Install the extension using Jason Extension Manager
2. Get an API key from [segment.io](https://www.segment.io)
3. From your Android studio project, open `strings.xml`. Add a new property called `segment`, and add your API key there. Here's an example:

```
<string name="segment">genNIKQFiHP59px7DBtvypDCp0l7cVBA</string>
```

# Usage

## 1. Identifying Users
Implements [identify](https://segment.com/docs/sources/mobile/ios/#identify)

```
{
    “type”: “$segment.identify”,
    “options”: {
        “id”: “…”,
        “traits”: {…}
    }
}
```

## 2. Tracking Events
Implements [tracking](https://segment.com/docs/sources/mobile/ios/#track)

```
{
    “type”: “$segment.track”,
    “options”: {
        “event”: “…”,
        “properties”: {
        }
    }
}
```

# Note

All $segment actions propagates the return value from its previous action onto the next action.

For example, take a look at this example:

```
{
	"type": "$network.request",
	"options": {
		"url": "https://www.jasonbase.com/things/n3s.json"
	},
	"success": {
		"type": "$segment.track",
		"options": {
			"result": "{{$jason}}"
		},
		"success": {
			"type": "$render"
		}
	}
}
```

Above works the same as the following JSON (Except that the results are sent to segment.io between `network.request` and `render`)


```
{
	"type": "$network.request",
	"options": {
		"url": "https://www.jasonbase.com/things/n3s.json"
	},
	"success": {
		"type": "$render"
	}
}
```

This is because the `$segment.track` action propagates the `$jason` object from `$network.request` onto the next action (`$render`)
