define(function(require) {

  require('controllers/app');
    
  var loggedOut = require('states/loggedout'),
      loggedIn = require('states/loggedin');

  Radium.App = Ember.StateManager.create({
    isLoggedIn: NO,
    
    loggedOut: loggedOut,
    
    loggingIn: Ember.State.create({
      enter: function(manager, transition) {
        // TODO: Set up form validation logic here.
        console.log('logging in...')
        transition.async();
        transition.resume();
        manager.goToState('loggedIn');
      },
      exit: function(manager, transition) {
        ISLOGGEDIN = true;
        console.log('login successful!');
      }
    }),
    
    loggedIn: loggedIn,
    
    error: Ember.State.create({
      enter: function() {
        console.log('error');
      }
    })
  });
  
});