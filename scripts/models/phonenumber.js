define('models/phonenumber', function(require) {
  
  require('ember');
  require('data');
  var Radium = require('radium');
  require('./core');
  
  Radium.PhoneNumber = Radium.Core.extend({
    name: DS.attr('string'),
    value: DS.attr('string'),
    accepted_values: DS.attr('string'),
  });
  
  return Radium;
  
});