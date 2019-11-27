var fetch = function() {
  var items = [];
  document.querySelectorAll(".storylink").forEach(function(link) {
    items.push( { text: link.innerText, url: link.href } )
  })
  $agent.response({"items": items})
}
