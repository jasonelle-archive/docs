components = [
  label_component("It's ALIVE!",   align: :center, font: "Courier-Bold", size: "18"),
  label_component("This is a demo app. You can make your own app by changing the url inside settings.plist", align: :center, font: "Courier",padding: "10", size: "14"),
  label_component("{ ˃̵̑ᴥ˂̵̑}", align: "center", font: "HelveticaNeue-Bold", size: "50"),
]
items =  [
  image_item("rails-logo.png"),
  vertical_item(components),
  menu_item("Check out Live DEMO",      {url: "file://demo.json", fresh: "true"}),
  menu_item("Watch the tutorial video", {url: "https://www.youtube.com/watch?v=hfevBAAfCMQ", view: "Web"}),
  menu_item("View documentation",       {url: "https://jasonette.github.io/documentation", view: "Web"}),
]

json.sections do
  json.child! do
    json.items(items){ |item| json.merge! item }
  end
end
