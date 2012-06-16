/**
  `Radium.App` is the application State Manager.

  The flow goes like this:

  1.  A URL request is intercepted via `Radium.Routes`, sending a `loadPage`
      action.
  2.  `loadPage` determins whether if the user is logged in and if this is 
      the first visit of the sesson. Obviously if the vistor is not logged in,
      we must punt them to the `loggedOut` state.
  3.  If the visitor is logged in, the first step is to load all the account's
      users. All these records are important to start the application with as
      much data as possible on load.
      
*/

Radium.App = Ember.StateManager.create({
  enableLogging: true,
  
  loggedOut: Radium.LoggedOutState,

  start: Ember.State.extend({
    enter: function(manager, transition){
      this._super(manager, transition);
      $('#main').empty();
    }
  }),

  init: function(){
    Radium.set('appController', Radium.AppController.create());
    Radium.set('accountController', Radium.AccountController.create());
    Radium.set('announcementsController', Radium.AnnouncementsController.create());
    Radium.set('todosController', Radium.TodosController.create());
    Radium.set('usersController', Radium.UsersController.create());
    Radium.set('activityFeedController', Radium.ActivityFeedController.create());
    Radium.set('overdueActivitiesController', Radium.OverdueActivitiesController.create());
    Radium.set('scheduledActivitiesController', Radium.ScheduledActivitiesController.create());
    Radium.set('contactsController', Radium.ContactsController.create());
    Radium.set('everyoneController', Radium.EveryoneController.create({
      usersControllerBinding: 'Radium.usersController',
      contactsControllerBinding: 'Radium.contactsController'
    }));
    this._super();
  },

  // TODO: Add server login logic here.
  authenticate: Ember.State.extend({
    enter: function(manager, transition) {
      this._super(manager, transition);

      manager.set('rootView', Radium.LoadingView.create());
      manager.get('rootView').appendTo('#main');

      $.when(manager.bootstrapUser()).then(function(data){
        Radium.get('appController').bootstrap(data);
        
        manager.send('loginComplete');
      },
      function() {
        manager.send('accountLoadFailed');
      });
    },
    loginComplete: function(manager) {
      manager.transitionTo('loggedIn');
    },
    accountLoadFailed: function(manager) {
      manager.transitionTo('loggedOut.error');
    }
  }),
  
  loggedIn: Radium.LoggedIn,
  dashboard: Radium.DashboardPage,
  contacts: Radium.ContactsPage.create(),
  // users: Radium.UsersPage.create(),
  // deals: Radium.DealsPage.create(),
  // pipeline: Radium.PipelinePage.create(),
  // campaigns: Radium.CampaignsPage.create(),
  // calendar: Ember.State.create({}),
  // messages: Ember.State.create({}),
  // settings: Ember.State.create({}),
  // noData: Ember.ViewState.create({
  //   view: Ember.View.extend({
  //     templateName: 'error_page'
  //   })
  // }),
  
  error: Ember.State.create({
    enter: function() {
      console.log('error');
    }
  }),
  /**
    ACTIONS
    ------------------------------------
  */
  loadPage: function(manager, context) {
    var app = Radium.get('appController'),
        page = context.page,
        action = context.action || 'index',
        statePath = [page, action].join('.'),
        routeParams = [];

    app.setProperties({
      _statePathCache: statePath,
      currentPage: context.page,
      params: (context.param) ? context.param : null
    });

    if (!Radium.get('_api')) {
      manager.transitionTo('loggedOut');
      return false;
    }

    if (Radium.get('appController').get('account')) {
      manager.transitionTo(statePath);
    } else {
      manager.transitionTo('authenticate');
    }
  },
  bootstrapUser: function() {
    return $.ajax({url: '/api/bootstrap'});
  }
});
