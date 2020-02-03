
*Jay* is an easier way to develop apps for *Jasonette*. It's a series of *Javascript* functions that allows creating a json object.

- *Github*: [https://github.com/jasonelle/jay](https://github.com/jasonelle/jay).


## Hello World
Instead of writing directly *JSON* you could write a set of *Javascript* functions that will output the same json. With this approach you get all the benefits of the *Javascript* language like string concatenation, comments and other goodies.

```js
    // These are Jay functions
    console.log(
        document().jason({
            head: head()
                .title('My App')
                .description('Made using Jay and Jasonette')
                .offline()
                .value()
        }).json()
    );
```

Will generate the following output

```json
{
    "$jason": {
        "head": {
            "title": "My App",
            "description": "Made using Jay and Jasonette",
            "offline": true
        }
    }
}
```

Using *Jay* functions is better to using direct json
because it will validate and format the values. Less human
errors will be made.