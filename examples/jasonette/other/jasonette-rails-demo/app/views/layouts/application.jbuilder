json.set! "$jason" do
  json.head do
    json.partial! 'layouts/head', as: :head
  end
  json.body do
    json.partial! "layouts/header", as: :header
    json.partial! "layouts/app_style", as: :style
    json.merge! JSON.parse yield
  end
end
