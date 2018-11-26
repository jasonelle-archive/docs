json.set! "$jason" do
  json.head do
    json.title "Posts"
    json.actions do
      json.set! "$pull" do
        json.type "$util.alert"
        json.options do
          json.title "Post"
          json.description "Post something"
          json.form do
            json.child! do
              json.name "post"
              json.placeholder "new message"
            end
          end
        end
        json.success do
          json.type "$network.request"
          json.options do
            json.method "post"
            json.url posts_url(format: :json)
            json.data do
              json.set! "post[content]", "{{$jason.post}}"
            end
          end
          json.success do
            json.type "$reload"
          end
        end
      end
    end
  end
  json.body do
    json.style do
      json.border "none"
      json.background "#646464"
    end
    json.header do
      json.title "Posts"
      json.style do
        json.background "#646464"
        json.color "#ffffff"
      end
      json.menu do
        json.text "Sign out"
        json.action do
          json.type "$session.reset"
          json.options do
            json.domain "sessionjason.herokuapp.com"
          end
          json.success do
            json.type "$reload"
          end
        end
      end
    end
    json.sections do
      json.child! do
        json.items do
          json.array!(@posts) do |post|
            json.type "vertical"
            json.components do
              json.child! do
                json.type "label"
                json.text post.content
                json.style do
                  json.color "#ffffff"
                  json.size "15"
                  json.font "HelveticaNeue"
                end
              end
              json.child! do
                json.type "label"
                json.text "#{post.user.email.split(/@/)[0]} : #{time_ago_in_words(post.created_at)} ago"
                json.style do
                  json.color "#ebebeb"
                  json.size "12"
                  json.font "HelveticaNeue"
                end
              end
            end
          end
        end
      end
    end
  end
end
