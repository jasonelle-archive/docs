var Post;
var express = require('express');
var aws = require('aws-sdk');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json()); // support json encoded bodies
app.use(bodyParser.urlencoded({ extended: true })); // support encoded bodies

var mongoose = require ("mongoose"); // The reason for this demo.

/*************************************************************
*
* How this works
* 
* var jason:
*   is the JSON stub that will be filled out
*   and returned, depending on the result.
*
*   If everything goes well,
*     the server will return jason["success"]
*
*   If something goes wrong,
*     the server will return jason["error"]
*
* var init:
*   takes care of initializations
*
*   init.db(): initializes mongodb
*   init.server(): initializes express server
*
*************************************************************/

var jason = {
  "error": {
    "$jason": {
      "head": {
        "title": "Error"
      },
      "body": {
        "layers": [{
          "type": "label",
          "text": "Something went wrong",
          "style": {
            "top": "50%-50",
            "left": "50%-100",
            "width": "200",
            "align": "center",
            "padding": "0",
            "height": "100",
            "font": "Avenir",
            "size": "14"
          }
        }]
      }
    }
  },
  "success": {
    "$jason": {
      "head": {
        "title": "image sample",
        "data": {
          "db": []
        },
        "actions": {
          "$load": {
            "type": "$set",
            "options": {
              "selected": ""
            },
            "success": {
              "type": "$render"
            }
          },
          "$pull": {
            "type": "$media.camera",
            "options": {
              "quality": "0.4"
            },
            "success": {
              "type": "$network.upload",
              "options": {
                "type": "s3",
                "bucket": "fm.ethan.jason",
                "data": "{{$jason.data}}",
                "content_type": "{{$jason.content_type}}",
                "path": "",
                "sign_url": "https://imagejason.herokuapp.com/sign_url"
              },
              "success": {
                "type": "$network.request",
                "options": {
                  "url": "https://imagejason.herokuapp.com/post",
                  "method": "post",
                  "data": {
                    "bucket": "fm.ethan.jason",
                    "path": "/",
                    "filename": "{{$jason.filename}}"
                  }
                },
                "success": {
                  "type": "$reload"
                }
              }
            }
          }
        },
        "templates": {
          "body": {
            "style": {
              "border": "none"
            },
            "header": {
              "menu": {
                "text": "View Full Source",
                "href": {
                  "url": "https://github.com/Jasonette/s3-upload-example/blob/master/app.js",
                  "view": "web"
                }
              }
            },
            "sections": [
              {
                "style": {
                  "spacing": "0",
                  "padding": "0"
                },
                "header": {
                  "type": "vertical",
                  "style": {
                    "align": "center",
                    "padding": "20",
                    "z_index": "-1"
                  },
                  "components": [{
                    "type": "image",
                    "url": "https://d30y9cdsu7xlg0.cloudfront.net/png/126349-200.png",
                    "style": {
                      "z_index": "-1",
                      "width": "100"
                    }
                  }]
                },
                "items": [
                  {
                    "{{#if db && db.length > 0}}": {
                      "{{#each db}}": {
                        "type": "image",
                        "style": {
                          "width": "100%",
                          "padding": "0"
                        },
                        "url": "{{url}}"
                      }
                    }
                  }, { 
                    "{{#else}}": []
                  }
                ]
              }
            ]
          }
        }
      }
    }
  }
};



var init = {
  /**********************************************************************
  *
  * DB Initialization
  * 
  **********************************************************************/
  db: function(){
    var uristring = process.env.MONGODB_URI;
    var theport = process.env.PORT || 5000;

    mongoose.connect(uristring, function (err, res) {
      if (err) {
        console.log ('ERROR connecting to: ' + uristring + '. ' + err);
      } else {
        console.log ('Succeeded connected to: ' + uristring);
      }
    });
    var postSchema = new mongoose.Schema({
      url: String
    });
    Post = mongoose.model('posts', postSchema);
  },

  /**********************************************************************
  *
  * Server Initialization
  * 
  **********************************************************************/
  server: function(){

    var respond = function(res){
      /**********************************************************************
      *
      * 1. Fetches the entire DB
      * 2. Fills in the "data" portion of the template with DB
      * 3. Returns the response
      * 
      **********************************************************************/
      
      Post.find({}).sort({_id: -1}).exec(function(err, result) {
        // Fetch all items in the DB
        if (err) {
          res.json(jason["error"]);
        } else {
          jason["success"]["$jason"]["head"]["data"]["db"] = result;
          res.json(jason["success"]);
        }
      });
    };

    // ROUTING
    app.get('/', function (req, res) {
      // Display all pics
      respond(res);
    });
    app.post('/post', function(req,res){
      // Add a post entry to DB after the upload finishes
      var url = "https://s3-us-west-2.amazonaws.com/" + req.body.bucket + req.body.path + req.body.filename;
      var post = new Post({url: url});
      post.save(function (err) {
        if (err) {
          console.log ('Error on save!');
        }
      });
      respond(res);
    });
    app.get('/sign_url', function (req, res) {
      // Return an s3 signed url so the client can directly upload to S3 through the signed url
      aws.config.update({region: "us-west-2", endpoint: "https://s3-us-west-2.amazonaws.com", accessKeyId: process.env.S3_KEY, secretAccessKey: process.env.S3_SECRET});
      var s3 = new aws.S3();
      var s3_params = {
        Bucket: req.query.bucket,
        Key: req.query.path,
        Expires: 60,
        ACL: "public-read",
        ContentType: req.query['content-type']
      };
      s3.getSignedUrl('putObject', s3_params, function(err, data){
        if(err) {
          console.log(err);
          res.json(jason["error"]);
        } else {
          res.json({"$jason": data});
        }
      });
    });

    app.listen(process.env.PORT || 3000);
  }
};

init.db();
init.server();
