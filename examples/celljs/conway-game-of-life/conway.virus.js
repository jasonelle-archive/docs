/************************************************
*
* "Conway's game of life" virus
* Generates a cell from a DNA array
*
************************************************/

var Conway = function(options) {
  var pixel = function (state) {
    return {
      class: "pixel",
      style: { display: "inline-block", width: "20px", height: "20px", background: (state.val ? state.color : 'transparent') }
    }
  }
  var newOptions = {
    id: 'life',
    style: { background: "black", position: "absolute", left: "50%", top: "50%", marginLeft: "-150px", marginTop: "-150px" },
    $init: function() {
      this._initialize(this._dna);
    },
    _interval: null,
    _initialize: function(dna) {
      console.log(dna)
      this._state = dna;
      var self = this;
      this._interval = setInterval(function() {
        self._evolve(); 
      }, 100);
    },
    _state: [],
    _evolve: function() {
      var rows = this._state.length;
      var columns = this._state[0].length;
      var next = this._state;
      var nextColor = "";
      for (var x = 1; x < columns-1; x++) {
        for (var y = 1; y < rows-1; y++) {
          var neighbors = 0;
          for (var i = -1; i <= 1; i++) {
            for (var j = -1; j <= 1; j++) {
              neighbors += this._state[x+i][y+j].val;
            }
          }
          neighbors -= this._state[x][y].val;
          if      ((this._state[x][y].val == 1) && (neighbors <  2)) next[x][y].val = 0;
          else if ((this._state[x][y].val == 1) && (neighbors >  3)) next[x][y].val = 0;
          else if ((this._state[x][y].val == 0) && (neighbors == 3)) next[x][y].val = 1;
          else next[x][y].val = this._state[x][y].val;
        }
      }
      this._state = next;
    },
    $update: function() {
      this.$components = this._state.map(function(row) {
        return { $components: row.map(pixel) }
      })
    },
  }
  Object.keys(options).forEach(function(key) {
    newOptions[key] = options[key];
  })
  return newOptions;
}
