define(function(require) {
    
  var topBarView = require('views/topbar').create(),
      globalSearchView = require('views/globalsearch').create(),
      _dashboard = require('states/dashboard');
  
  return Ember.StateManager.create({
    enter: function() {
      console.log('logged in');
      $('#main-nav').show();
      topBarView.appendTo('#topbar');
    },
    exit: function() {
      console.log('exiting');
    },
    dashboard: _dashboard,
    contacts: Ember.State.create({}),
    pipeline: Ember.State.create({}),
    campaigns: Ember.State.create({}),
    calendar: Ember.State.create({}),
    messages: Ember.State.create({}),
    settings: Ember.State.create({})
  });
  
});