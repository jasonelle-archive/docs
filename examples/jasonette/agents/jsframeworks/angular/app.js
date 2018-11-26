'use strict';

// Define the `phonecatApp` module
var phonecatApp = angular.module('phonecatApp', []);

/****************************************
Jasonette Agent Injection
****************************************/
// When $agent doesn't exist (when not used within Jasonette), just use a debugging function
if (!window.$agent) {
  window.$agent = {
    response: function(item) {
      console.log("response ", item)
    }
  }
}
// Inject Jasonette $agent into Angular controller
phonecatApp.factory('$agent', () => $agent)
// Allow global access into angular component
var add = function(name, snippet) {
  angular.element(document.querySelector("#phonelist")).scope().addItem({name: name, snippet: snippet});
}
var all = function() {
  angular.element(document.querySelector("#phonelist")).scope().all();
}

// Define the `PhoneListController` controller on the `phonecatApp` module
phonecatApp.controller('PhoneListController', ['$scope', '$agent', function PhoneListController($scope) {
  $scope.name = "";
  $scope.snippet = "";
  $scope.phones = [
    {
      name: 'Nexus S',
      snippet: 'Fast just got faster with Nexus S.'
    }, {
      name: 'Motorola XOOM™ with Wi-Fi',
      snippet: 'The Next, Next Generation tablet.'
    }, {
      name: 'MOTOROLA XOOM™',
      snippet: 'The Next, Next Generation tablet.'
    }
  ];
  $scope.add = function() {
    $scope.addItem({
      name: $scope.name,
      snippet: $scope.snippet
    });
  }
  $scope.addItem = function(item) {
    $scope.phones.push(item);
    $agent.response($scope.phones);
  }
  $scope.all = function() {
    $agent.response($scope.phones)
  }
}]);
