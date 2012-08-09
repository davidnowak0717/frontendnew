// TODO: Move this to it's own file once POC is completed
Radium.MeetingFormController = Ember.Object.create({
  topicValue: null,
  locationValue: null,
  startsAtValue: Ember.DateTime.create(),
  endsAtValue: Ember.DateTime.create(),
  // Transform the defaults to a rounded time
  startsAtDateValue: function(key, value) {
    // Getter
    if (arguments.length === 1) {
      var now = this.get('startsAtValue'),
          hour = now.get('hour'),
          minute = now.get('minute'),
          start;

      if (minute < 30) {
        start = now.adjust({
          minute: 30
        });
      } else {
        start = now.adjust({
          hour: hour+1,
          minute: 0
        });
      }
      return start;
    // Setter
    } else {
      this.set('startsAtValue', value);
      return value;
    }
  }.property('startsAtValue'),
  endsAtDateValue: function(key, value) {
    if (arguments.length === 1) {
      return this.get('startsAtDateValue').advance({hour: 1});
    } else {
      this.set('endsAtValue', value);
      return value;
    }
  }.property('startsAtDateValue'),
  daysSummary: Ember.A([])
});


Radium.MeetingForm = Radium.FormView.extend({
  templateName: 'meeting_form',

  init: function() {
    this._super();

    this.set('controller', Radium.MeetingFormController.create());

    this.set('inviteesList', Ember.ArrayController.create({
      contentBinding: 'Radium.everyoneController.emails',
      selected: Ember.A([])
    }));
  },

  willDestroyElement: function() {
    this.get('inviteesList').destroy();
    this.get('controller').destroy();
  },

  topicValue: null,
  locationValue: null,
  startsAtValue: null,
  endsAtValue: null,
  daysSummary: Ember.A(),

  isValid: function() {
    return (this.getPath('invalidFields.length')) ? false : true;
  }.property('invalidFields.@each').cacheable(),

  topicField: Ember.TextField.extend({
    placeholder: "Meeting description",
    valueBinding: 'parentView.controller.topicValue'
  }),

  locationField: Ember.TextField.extend({
    placeholder: "Location",
    valueBinding: 'parentView.controller.locationValue'
  }),

  inviteField: Radium.AutocompleteTextField.extend(Radium.EmailFormGroup, {
    selectedGroupBinding: 'parentView.inviteesList',
    sourceBinding: 'selectedGroup.content',
    placeholder: function() {
      var numOfInvitees = this.getPath('parentView.inviteesList.selected.length');
      return (numOfInvitees) ? "" : "Invitees";
    }.property('parentView.inviteesList.selected.length')
  }),

  selectedInvitees: Ember.View.extend({
    contentBinding: 'parentView.inviteesList.selected'
  }),

  meetingStartDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    dateValueBinding: 'controller.startsAtDateValue',
    elementId: 'start-date',
    viewName: 'meetingStartDate',
    name: 'start-date'
  }),

  meetingEndDateField: Radium.MeetingFormDatepicker.extend({
    controllerBinding: 'parentView.controller',
    dateValueBinding: 'controller.endsAtDateValue',
    elementId: 'end-date',
    viewName: 'meetingEndDate',
    name: 'end-date'
  }),

  daysActivities: Ember.CollectionView.extend({
    contentBinding: "parentView.controller.daysSummary",
    classNames: ['other-meetings'],
    tagName: 'table',
    isVisible: function() {
      return (this.getPath('parentView.daysSummary')) ? true : false;
    }.property('parentView.daysSummary'),
    emptyView: Ember.View.extend({
      tagName: 'tr',
      classNames: ['no-meetings'],
      template: Ember.Handlebars.compile('<td colspan="2">No meetings scheduled.</td>')
    }),
    itemViewClass: Ember.View.extend({
      tagName: 'tr',
      template: Ember.Handlebars.compile('<td>{{formatTime content.startsAt}}</td><td>{{content.topic}}</td>')
    })
  }),

  startsAtField: Ember.TextField.extend(Radium.TimePicker, {
    classNames: ['time'],
    dateBinding: 'parentView.controller.startsAtDateValue'
  }),

  endsAtField: Ember.TextField.extend(Radium.TimePicker, {
    classNames: ['time'],
    dateBinding: 'parentView.controller.endsAtDateValue',
    dateDidChange: function() {
      var isoTime = this.get('date').toISO8601();
      if (this.$().timepicker().length) {
        this.$().timepicker('setTime', new Date(isoTime));
      }
    }.observes('date')
  }),

  submitForm: function() {
    var meeting,
        self = this,
        topic = this.get('topicValue'),
        location = this.get('locationValue'),
        day = this.getPath('meetingStartDate.value'),
        date = Ember.DateTime.parse(day, '%Y-%m-%d'),
        startsAt = this.get('startsAtValue'),
        endsAt = this.get('endsAtValue'),
        endsAtMeridian = this.$('#end-time-meridian').val(),
        invitees = this.getPath('inviteesList.selected'),

        data = {
          topic: topic,
          startsAt: date.adjust({
            hour: startsAt.getHours(),
            minute: startsAt.getMinutes()
          }),
          endsAt: date.adjust({
            hour: endsAt.getHours(),
            minute: endsAt.getMinutes()
          }),
          location: location,
          invite: invitees.map(function(invitee) {
            if (invitee.get('email')) {
              return invitee.get('email');
            } else {
              return invitee.getPath('emailAddresses.firstObject.value');
            }
          })
        };

    meeting = Radium.store.createRecord(Radium.Meeting, data);

    Radium.store.commit();

    this.get('parentView').close();
    return false;
  }
});
