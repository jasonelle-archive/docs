var View = {
  h1: function(title) {
    return { $type: "h1", $text: title };
  },
  h2: function(title) {
    return { $type: "h2", $text: title };
  },
  h3: function(title) {
    return { $type: "h3", $text: title };
  },
  json: function(o) {
    return { $type: "pre", $text: JSON.stringify(o, null, 2) }
  }
}
