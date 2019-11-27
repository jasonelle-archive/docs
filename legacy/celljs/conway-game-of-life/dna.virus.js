/************************************************
*
* DNA virus
* Methods to handle re-generation of DNA
*
************************************************/

var DNA = function(options) {

  options.onclick = function(e) {
    clearInterval(this._interval);
    this._initialize(this._generate(16, 16));
  };

  /*******************************************
  *
  * Generates a random DNA sequence
  * which looks like:
  *
  *  [[
  *    {"val":1,"color":"#45f1c9"},
  *    {"val":0,"color":"#8c3696"},
  *    {"val":0,"color":"#94f879"},
  *    {"val":0,"color":"#05bc8e"},
  *    ...
  *  ], [
  *    ...
  *  ]]
  *
  *******************************************/
  options._generate = function(width, height) {
    var arr = [];
    for(var i=0; i<width; i++) {
      arr[i] = [];
      for(var j=0; j<height; j++) {
        var color = '#' + Math.round((0x1000000 + 0xffffff * Math.random())).toString(16).slice(1);
        arr[i][j] = (Math.random() > 0.9) ? {val: 1, color: color} : {val: 0, color: color};
      }
    }
    console.log("Generated DNA = ", arr);
    return arr;
  }
  return options;
}
