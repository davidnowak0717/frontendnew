Radium.FormContainerView = Ember.ContainerView.create({
  elementId: 'form-container',
  
  isVisible: function() {
    return (this.get('currentView')) ? true : false;
  }.property('currentView'),

  close: function(event) {
    var self = this,
        form = this.get('currentView');
    form.$().fadeOut('fast', function() {
      self.set('currentView', null);
      form.destroy();
    });
    return false;
  },

  show: function(form) {
    this.set('currentView', form);
  },

  // Individual Forms
  showEmailForm: function(event) {
    var context = (event) ? event.context : null,
        // Test if context is an array controller versus an object
        isArray = Ember.Array.detect(context),
        // If it is an array, we wanted the selected computed property,
        // but if not, just pass the defined object along.
        multipleBinding = {
          source: context,
          selectionBinding: 'source.selectedContacts'
        },
        singleBinding = {
          selection: context
        },
        selection = (isArray) ? multipleBinding : singleBinding;

    var controller = Ember.Object.create({
      to: Ember.A([]),
      cc: Ember.A([]),
      bcc: Ember.A([])
    });


    this.show(Radium.MessageForm.create({
      controller: controller
    }));

    return false;
  },

  showTodoForm: function(event) {
    var context = (event) ? event.context : null,
        // Test if context is an array controller versus an object
        isArray = Ember.Array.detect(context),
        // If it is an array, we wanted the selected computed property,
        // but if not, just pass the defined object along.
        multipleBinding = {
          source: context,
          selectionBinding: 'source.selectedContacts'
        },
        singleBinding = {
          selection: context
        },
        selection = (isArray) ? multipleBinding : singleBinding;

    this.show(Radium.TodoForm.create(selection));

    return false;
  },

  showDealForm: function(event) {
    var form = Radium.DealForm.create();
    this.show(form);
  },

  showMeetingForm: function(event) {
    var form = Radium.MeetingForm.create();
    this.show(form);
  },

  showContactForm: function(event) {
    var form = Radium.ContactForm.create();
    this.show(form);
  },

  showAddToGroupForm: function(event) {
    var form = Radium.AddToGroupForm.create();
    this.show(form);
  },
}).append();