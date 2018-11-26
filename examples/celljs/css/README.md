# css.cell

Construct CSS from JSON, powered by [cell.js](https://github.com/intercellular/cell)

# Install

Just include the following script

```
<script src="https://gliechtenstein.github.io/css.cell/css.cell.js"></script>
```

# Usage

```
var stylesheet = css({
  ".page": {
    "position": "fixed",
    "top": "0",
    "left": "0",
    "width": "100%",
    "height": "100%",
    "padding": "0",
    "margin": "0",
    "font-size": "200px",
    "text-align": "center",
    "line-height": "100vh",
    "background": "white",
    "-webkit-transition": "left 0.5s",
    "cursor": "pointer",
    "transition": "left 0.5s"
  },
  ".page.hidden": {
    "left": "100%"
  }
}, true)
```

creates a `<style>` node that looks like this:

```
<style>
.page {
  position: fixed;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
  padding: 0;
  margin: 0;
  font-size: 200px;
  text-align: center;
  line-height: 100vh;
  background: white;
  -webkit-transition: left 0.5s;
  cursor: pointer;
  transition: left 0.5s;
}
.page.hidden {
  left: 100%;
}
</style>
```

# Demo 

Check out the demo at https://play.celljs.org/items/glkfXy/edit

# Syntax

```
css([Style JSON], [Include $cell?])
```

1. The first argument is the actual JSON that represents the CSS.
2. The second argument, when set to `true`, simply attaches `$cell: true` to the response, making sure it turns into a cell node.
