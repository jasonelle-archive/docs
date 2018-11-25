# JasonDateAction (iOS)
A Simple Date Action for obtaining the current date and change formatting.

Supports Formats from: [https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html](https://developer.apple.com/library/content/documentation/Cocoa/Conceptual/DataFormatting/Articles/dfDateFormatting10_4.html)

And Locales from : [https://developer.apple.com/reference/foundation/nslocale/1416263-localeidentifier](https://developer.apple.com/reference/foundation/nslocale/1416263-localeidentifier)

For use with 
[http://jasonette.com](http://jasonette.com)

## Licence
MIT

## Usage

### $date.now

Returns the current date and the timezone information retrieved from the phone. Defaults to `ISO 8601` (`yyyy-MM-dd'T'HH:mm:ssZZZZZ`) Format and `en_US_POSIX` locale.

### Params

- format (optional, defaults=`ISO8601`)
- locale (optional, defaults=`en_US_POSIX`)

```json
{
    "type": "$date.now",
     "options": {
     }
}
```

#### Result

```json
{
	"date" : "2017-02-19T13:53:47-03:00", 
	"unix" : "1487523227.613869",
    "format" : "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
    "locale" : "en_US_POSIX",
	"timezone" : {
	   "name" : "America/Santiago",
	   "secondsFromGMT" : "-10800"
	}
}
```

### $date.format
Retrieves a date in a given format and output in another format.

#### Params

- date (required)
- format (optional, defaults=`ISO8601`)
- formatOut (optional, defaults=`ISO8601`)
- locale (optional, defaults=`en_US_POSIX`)

```json
{
  "type" : "$date.format",
  "options" : {
     "date" : "19/02/2017",
     "format" : "dd/MM/yyyy"
  }
}
```

#### Result

```json
{
  "date" : "2017-02-19T13:53:47-03:00", 
  "unix" : "1487523227.613869",
  "format" : "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
  "locale" : "en_US_POSIX"
}
```

### $date.unix
Transforms a Unix Timestamp into a Formatted Date. Defaults to `ISO 8601` (`yyyy-MM-dd'T'HH:mm:ssZZZZZ`) Format and `en_US_POSIX` locale.

### Params

- date (required)
- format (optional, defaults=`ISO8601`)
- locale (optional, defaults=`en_US_POSIX`)

```json
{
    "type": "$date.unix",
     "options": {
        "date" : "1487523227.613869"
     }
}
```

#### Result

```json
{
  "date" : "2017-02-19T13:53:47-03:00", 
  "unix" : "1487523227.613869",
  "format" : "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
  "locale" : "en_US_POSIX",
}
```

### Test App
[https://raw.githubusercontent.com/NinjasCL/JasonDateAction/master/test.json](test.json)

Made with <i class="fa fa-heart">&#9829;</i> by <a href="http://ninjas.cl" target="_blank">Ninjas.cl</a>.
