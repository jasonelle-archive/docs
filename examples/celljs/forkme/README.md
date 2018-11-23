# Fork Me on Github Cell

A cell.js component for the "Fork me on Github" banner.

Simply call `ForkMe()` with your repo URL as param.

![screenshot](./example/screenshot.png)

<br>

## Demo

View the demo [here](https://intercellular.github.io/forkme/example)

<br>

## Usage

```js
var app = {
  $cell: true,
  $components: [

    /******************

      Your app goes here 

    ******************/,

    ForkMe(YOUR_REPO_URL)

  ]
}
```

<br>

## Example

```html
<html>
<script src="https://www.celljs.org/cell.js"></script>
<script src="https://intercellular.github.io/forkme/forkme.js"></script>
<script>
var app = {
  $cell: true,
  $components: [

    // My App
    {
      class: "list",
      $components: [{
        $type: "h1", $text: "Hello World"
      }, {
        $type: "p", $text: "This is an example app"
      }]
    },
    
    // Fork Me on Github
    ForkMe("https://github.com/intercellular/forkme")

  ]
}
</script>
</html>
```
