var Component = {
  keygen: {
    build: function(options) {
      return {
        $components: [
          options.view.title(options.model.algorithm + " " + options.model.export)].concat(Component.keygen.keys(options))
      }
    },
    keys: function(options) {
      return {
        $init: function() {
          var self = this;
          Model.generate[options.model.algorithm]().then(function(keys) {
            Promise.all(options.model.export.map(function(exportItem) {
              return Model.export(keys[exportItem])
            }))
            .then(function(exported_keys) {
              self._refresh(exported_keys) 
            })
          })
        },
        _refresh: function(items) {
          this.$components = items.map(options.view.content)
        }
      }
    }
  }
}
