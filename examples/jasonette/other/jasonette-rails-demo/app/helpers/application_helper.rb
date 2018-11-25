module ApplicationHelper

  def json_builder
    builder = Jbuilder.new{ |json| yield(json) }
    JSON.parse builder.target!
  end

  def image_item filename
    json_builder do |json|
      json.type "image"
      json.url image_url(filename)
      json.style do
        json.align :center
        json.padding "30"
      end
    end
  end

  def label_component text, styles = {}
    json_builder do |json|
      json.type "label"
      json.text text
      json.style do
        styles.each do |k,v|
          json.set! k, v
        end
      end
    end
  end

  def vertical_item components
    json_builder do |json|
      json.type "vertical"
      json.style do
        json.padding "30"
        json.spacing "20"
        json.align :center
      end
      json.components(components) do |component|
        json.merge! component
      end
    end
  end

  def menu_item title, options
    json_builder do |json|
      json.type "label"
      json.style do
        json.align :right
        json.padding "10"
        json.color "#000000"
        json.font "HelveticaNeue"
        json.size "12"
      end
      json.text title
      json.href { options.each { |k,v| json.set! k, v } }
    end
  end
end
