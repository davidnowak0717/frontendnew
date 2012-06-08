Radium.ClusterListView = Ember.ContainerView.extend({
  childViews: [],
  
  init: function() {
    this._super();
    this.set('currentView', Radium.ClusterHeaderView.create());
  },

  removeActivities: function() {
    var childViews = this.get('childViews');
    if (childViews.get('length') === 2) {
      // NOTE: There doesn't seem to be a way to run an animation
      // when an Ember View is about to be destroyed, using jQuery.Deferred
      // as a work around until a better solution is found.
      $.when(childViews.objectAt(1).slideUp()).then(function() {
        childViews.popObject();
      });      
    }
  },

  loadActivities: function(ids) {
    var activities = Radium.store.findMany(Radium.Activity, ids),
        activityListController = Ember.ArrayProxy.create({
            content: activities
          }),
      activitiesListView = Radium.ClusterActivityListView.create({
          controller: activityListController,
          contentBinding: 'controller.content'
        });
    this.get('childViews').pushObject(activitiesListView);
  }
});