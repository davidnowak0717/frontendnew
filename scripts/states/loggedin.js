define(function(require) {
  require('views/topbar');
  require('views/dashboard');
    
  var topBarView = Radium.TopbarView.create(),
      dashboardState = require('states/dashboard');
  
  return Ember.StateManager.create({
    rootElement: '#main',
    enter: function() {
      console.log('logged in');
      $('#main-nav').show();
      topBarView.appendTo('#topbar');
    },
    exit: function() {
      console.log('exiting');
    },
    dashboard: dashboardState.create(),
    contacts: Ember.State.create({}),
    pipeline: Ember.State.create({}),
    campaigns: Ember.State.create({}),
    calendar: Ember.State.create({}),
    messages: Ember.State.create({}),
    settings: Ember.State.create({})
  });
  
});