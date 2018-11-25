# Upload to S3 example
This repository contains a JSON express server, which is both the backend AND the frontend for a [Jasonette app](https://www.jasonette.com) that lets you upload photos to S3.

## Demo
You can try the demo by playing [https://imagejason.herokuapp.com](https://imagejason.herokuapp.com) on Jasonette. [Learn more](http://www.jasonette.com)

## App workflow overview
Here's an overview of how this app works (both client side and server side).

(Note: Remember that on Jasonette, there's no code you need to write on the client side, you're basically building the client interface on the server. The JSON response is your app)

1. When the app starts, it starts an express server to accept web requests.
2. The server also connects to a mongodb instance 
3. When a Jasonette client makes a `GET` request to the root url (`/`), the server responds with a JSON markup.
4. The Jasonette client will interpret the JSON and render a native app on its side, which allows the user to take a photo by swiping down.
5. After the user takes a photo, it makes a `GET` request to `/sign_url` to get an S3 signed url.
6. The server generates and returns a signed url.
7. The Jasonette client uploads the photo directly to S3 using the signed url.
8. After the upload is over, it makes a `POST` request to the express server's `/post` endpoint, with the s3 image url.
9. The express server stores the url to the mongodb it's connected to.
10. Then it returns a JSON which contains the list of all the images in the DB.
11. The Jasonette client displays the result.

## How the JSON markup works

The response JSON markup describes how the view will be displayed, as well as actions.

There are a couple of important [actions](https://jasonette.github.io/documentation/actions) being used here.

1. Takes a photo using [$media.camera](https://jasonette.github.io/documentation/actions#mediacamera).
2. Then it makes a request to our server's `/sign_url` endpoint using [$network.request](https://jasonette.github.io/documentation/actions#networkrequest).
3. Then it uploads it to the S3 signed url using [$network.upload](https://jasonette.github.io/documentation/actions#networkupload).
4. After the upload is over, it makes a `POST` request to our server's `/post` endpoint with the S3 filename, and the server stores it, so it can be displayed.


## How the server-side code works

1. The server initializes a Mongo DB instance via `init.DB()`, and then starts an [express](https://expressjs.com) web server via `init.server()`.
2. When a Jasonette client hits the root URL (`/`), the server returns the JASON Markup, and the client renders it accordingly.
3. The Jasonette client listens for a `$pull` event, and when it happens (User pulls to refresh), it makes a POST request to `/sign_url` endpoint.
4. Upon a `/sign_url` POST request, the server generates and returns an S3 signed url using the `aws` module.
5. Jasonette client then takes the url and uploads the photo to that URL immediately.
6. Once the upload has finished, the Jasonette client makes a `$network.request` to `/post` endpoint.
7. The backend responds by storing that entry to the DB.

## Usage

You need to set the following environment variables to make the code work on your own server.

- **MONGODB_URI** - Set up a mongodb instance and use its URL (In my case I used a free instance of [mlab](https://www.mlab.com))
- **S3_KEY** - Your S3 key
- **S3_SECRET** - Your S3 secret

If you're using [heroku](https://heroku.com), you can learn more [here](https://devcenter.heroku.com/articles/config-vars)
