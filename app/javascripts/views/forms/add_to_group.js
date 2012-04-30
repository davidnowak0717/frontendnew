Radium.AddToGroupForm = Radium.FormView.extend({
  templateName: 'add_to_group',
  newGroupName: '',
  selectedGroup: null,
  groupSearchField: Radium.AutocompleteTextField.extend({
    attributeBindings: ['name'],
    name: 'contact-name',
    elementId: 'contact-name',
    classNames: ['span6'],
    sourceBinding: 'Radium.groupsController.namesWithObject',
    newGroupNameBinding: 'parentView.newGroupName',
    select: function(event, ui) {
      if ( ui.item ) {
        event.target.value = '';
        this.resetNewGroupName();
        event.preventDefault();
      }
      this.$().val(ui.item.label);
      this.setPath('parentView.selectedGroup', ui.item.group);
      this.testGroupName();
    },

    keyUp: function() {
      if (this.$().val() === '') {
        this.setPath('parentView.isValid', false);
        this.setPath('parentView.isError', true);
        this.setPath('parentView.isEmptyError', true);
        this.setPath('parentView.selectedGroup', null);
        this.resetNewGroupName();
      }
    },

    focusOut: function() {
      if (this.$().val() === '') {
        this.setPath('parentView.isValid', false);
        this.setPath('parentView.isError', true);
        this.setPath('parentView.isEmptyError', true);
        this.resetNewGroupName();
      } else {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.setPath('parentView.isEmptyError', false);
        this.testGroupName();
      }
    },

    resetNewGroupName: function() {
      this.set('newGroupName', null);
      this.setPath('parentView.willCreateNewGroup', false);
      this.setPath('parentView.selectedGroup', null);
    },

    testGroupName: function() {
      var groups = this.get('source').getEach('label'),
          value = this.$().val();
          
      if (groups.indexOf(value) < 0) {
        this.resetNewGroupName();
        this.setPath('parentView.willCreateNewGroup', true);
        this.set('newGroupName', value);
      } else {
        this.setPath('parentView.isValid', true);
        this.setPath('parentView.isError', false);
        this.setPath('parentView.isEmptyError', false);
      }
    }
  }),
  submitForm: function() {
    var self = this,
        selectedGroup = this.get('selectedGroup'),
        newGroupName = this.get('newGroupName'),
        selectedContact = Radium.selectedContactController.get('content');

    this.sending();
    if (selectedGroup) {
      selectedGroup.get('contacts').pushObject(selectedContact);
      selectedContact.get('groups').pushObject(selectedGroup);
      debugger;
      Radium.store.commit();
    } else {
      var newGroup = Radium.store.createRecord(Radium.Group, {
        name: newGroupName,
        contact_ids: [selectedContact.get('id')]
      });

      Radium.store.commit();
      newGroup.addObserver('isValid', function() {
        if (this.get('isValid')) {
          self.success("New group created");
        } else {
          // Anticipating more codes as the app grows.
          switch (this.getPath('errors.status')) {
            case 422:
              self.error("Something was filled incorrectly, try again?");
              break;
            default:
              self.error("Look like something broke. Report it so we can fix it");
              break;
          }
        }
      });

      newGroup.addObserver('isError', function() {
        if (this.get('isError')) {
          self.error("Look like something broke. Report it so we can fix it");
        }
      });
    }

    return false;
  }
});