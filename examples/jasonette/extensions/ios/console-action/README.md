# $console

Stops further execution of the action call chain and displays all the current variable values.

![console](https://raw.githubusercontent.com/gliechtenstein/images/master/console.png)

## Usage

### 1. Basic

```json
{
  "type": "$network.request",
  "options": {
    "type": "$console.debug"
  }
}
```


### 2. Evaluation
Does all of the above, but also evaluate the expression passed in, and display it under "evaluated"

Just pass in an `eval` attribute whose value is a template expression to be evaluated

```json
{
  "type": "$network.request",
  "options": {
    "type": "$console.debug",
    "options": {
      "eval": "{{$jason.items}}"
    }
  }
}
```


## Full Example

### JSON

```
{
  "$jason": {
    "head": {
      "title": "$console.debug test",
      "actions": {
        "$load": {
          "type": "$set",
          "options": {
            "adjective": "sparkling",
            "noun": "water"
          },
          "success": {
            "type": "$cache.set",
            "options": {
              "username": "gliechtenstein"
            },
            "success": {
              "type": "$network.request",
              "options": {
                "url": "https://jasonbase.com/things/gbe"
              },
              "success": {
                "type": "$console.debug",
                "options": {
                  "eval": "I love {{$get.adjective}} {{$get.noun}}"
                }
              }
            }
          }
        }
      }
    }
  }
}
```

### Result

![console](https://raw.githubusercontent.com/gliechtenstein/images/master/console.png)
