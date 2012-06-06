Radium.ContactsToolbarView = Ember.View.extend({
  contactsBinding: 'Radium.selectedContactsController.content',
  selectedCampaignBinding: 'Radium.selectedContactsController.selectedCampaign',
  selectedContactsBinding: 'Radium.contactsController.selectedContacts',
  selectedFilterBinding: 'Radium.selectedContactsController.selectedFilter',
  selectedLetterBinding: 'Radium.selectedContactsController.selectedLetter',
  // Bind all child buttons' `disabled` property here
  isContactsSelected: function() {
    return (this.getPath('selectedContacts.length') === 0) ? true : false;
  }.property('selectedContacts').cacheable(),

  /**
    Bulk assigns contacts status as Dead End, Opportunity, Prospect,
    Client or Lead. `Change Status` dropdown buttons call this.
  */
  assignStatus: function(event) {
    var contacts = this.get('selectedContacts'),
        newStatus = $(event.target).data('status');
    // Hide all open dropdown menus
    this.$('.btn-group').toggleClass('open');
    contacts.setEach('status', newStatus);
    Radium.contactsController.clearSelected();
    event.preventDefault();
    return false;
  },

  /**
    Opens New Message form in the main page state
  */
  emailButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      Radium.FormContainerView.show({
        form: 'Message'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens New Message form in the main page state
  */
  //TODO: Check with josh to see how this is supposed to work
  // addToGroupButton: Ember.View.extend({
  //   tagName: 'button',
  //   click: function() {
  //   Radium.get('formManager').send('showForm', {
  //     Radium.FormContainerView.show({
  //       form: 'AddToGroup',
  //       target: this.getPath('parentView.selectedContacts'),
  //       type: 'contacts'
  //     });
  //   },
  //   disabledBinding: 'parentView.isContactsSelected'
  // }),


  /**
    Opens New Message form in the main page state
  */
  addToCompanyButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      Radium.get('formManager').send('showForm', {
        form: 'AddToCompany',
        target: this.getPath('parentView.selectedContacts'),
        type: 'contacts'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),


  /**
    Opens New SMS form in the main page state
  */
  smsButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      Radium.App.send('addResource', {
        form: 'ContactSMS'
      });
      Radium.FormManager.send('showForm', {
        form: 'AddToCompany',
        target: this.getPath('parentView.selectedContacts'),
        type: 'contacts'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add Todo form in the main page state
  */
  todoButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      Radium.FormContainerView.show({
        form: 'Todo',
        target: this.getPath('parentView.selectedContacts'),
        type: 'contacts'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add to Call List form in the main page state
  */
  callListButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      // TODO: This might not be efficient
      var callLists = Radium.store.findAll(Radium.CallList);
      Radium.callListsController.set('content', callLists);
      Radium.App.send('addResource', {
        form: 'CallList'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Opens Add Campaign form in the main page state
  */
  addCampaignButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      Radium.App.send('addResource', {
        form: 'AddToCampaign'
      });
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Removes a selected user from a campaign
  */
  removeCampaignButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      var contacts = this.getPath('parentView.selectedContacts');
      contacts.forEach(function(item) {
        var campaigns = item.get('campaigns');
        item.get('campaigns').removeObjects(campaigns);
      }, this);

      Radium.store.commit();
    },
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Select all Contacts
  */
  selectAllButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      var selectedFilter = this.getPath('parentView.selectedFilter'),
          selectedLetter = this.getPath('parentView.selectedLetter');

      if (Radium.selectedContactsController.get('length')) {
        // Select contacts by name AND status
        if (selectedFilter && selectedLetter) {
          Radium.selectedContactsController
            .filterProperty('status', selectedFilter)
            .filterProperty('firstLetter', selectedLetter)
            .setEach('isSelected', true);
        // Select contacts by their name only (first name, first letter)
        } else if (selectedLetter) {
          Radium.selectedContactsController
            .filterProperty('firstLetter', selectedLetter)
            .setEach('isSelected', true);

        // Select contact by status only
        } else if (selectedFilter) {
          Radium.selectedContactsController
            .filterProperty('status', selectedFilter)
            .setEach('isSelected', true);
        } else {
          // Assume we're looking at everything and select all of them
          Radium.selectedContactsController.setEach('isSelected', true);
        }
      }
    }
  }),

  /**
    Select all Contacts
  */
  selectNoneButton: Ember.View.extend({
    tagName: 'button',
    click: function() {
      if (Radium.selectedContactsController.get('length')) {
        Radium.selectedContactsController.setEach('isSelected', false);
      } else {
        Radium.contactsController.setEach('isSelected', false);
      }
    }
  }),

  /**
    Opens dropdown menu to batch assign contacts
    @extend Radium.DropdownButton
  */
  statusButton: Radium.DropdownButton.extend({
    disabledBinding: 'parentView.isContactsSelected'
  }),

  /**
    Displays the number of contacts selected.
  */
  totalSelected: Ember.View.extend({
    selectedContactsBinding: 'Radium.contactsController.selectedContacts',
    isVisible: function() {
      return (this.getPath('selectedContacts.length')) ? true : false;
    }.property('selectedContacts').cacheable(),
    totalSelectedString: function() {
      var total = this.getPath('selectedContacts.length');
      return (total === 1) ? total + ' contact' : total + ' contacts';
    }.property('selectedContacts').cacheable()
  }),

  /**
    Letters Filter
    ----------------------------------- */
  lettersFilter: Ember.View.extend({
    letterButton: Ember.View.extend({
      tagName: 'button',
      selectedLetterBinding: 'Radium.selectedContactsController.selectedLetter',
      classNameBindings: ['isSelected:active'],
      isSelected: function() {
        return (this.get('letter') === this.get('selectedLetter')) ? true : false;
      }.property('selectedLetter').cacheable(),
      click: function(event) {
        var letter = this.get('letter');
        if (this.get('isSelected')) {
          Radium.selectedContactsController.set('selectedLetter', null);
        } else {
          Radium.selectedContactsController.set('selectedLetter', letter);
        }
      }
    })
  })
});
