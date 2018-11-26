var css = function(o, cell) {
  var stub = {
    $type: "style",
    $text: Object.keys(o).map(function(selector) {
      var output = "";
      // 1. first line
      output += (selector + " {\n");
      // 2. key/values
      var selected = o[selector];
      for(var attr in selected)
        output += ("\t" + attr + ": " + selected[attr] + ";\n");
      // 2. last line
      output += "}";
      return output;
    }).join("\n")
  }
  if (cell) { stub.$cell = true; }
  return stub;
}
