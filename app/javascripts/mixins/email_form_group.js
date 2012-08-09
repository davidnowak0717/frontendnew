Radium.EmailFormGroup = Ember.Mixin.create({
  classNames: ['token-field'],
  insertNewline: function(event) {
    event.preventDefault();
    var val = this.get('value');
    if (val) {
      if (Radium.Utils.VALIDATION_REGEX.email.test(val)) {
        var nonSystemEmail = Ember.Object.create({
              email: val
            });
          this.getPath('selectedGroup.selected').addObject(nonSystemEmail);
        this.set('value', null);
      }
    }
  },
  keyUp: function(event) {
    this._super(event);
    var value = this.get('value');
    if (value) {
      this.$().width(value.length * 8);
    } else {
      this.$().width('auto');
    }
  },
  select: function(event, ui) {
    event.preventDefault();
    this.get('selected').pushObject(ui.item.target);
    this.set('value', null);
    return false;
  },
  close: function(event, ui) {
    event.preventDefault();

    if (!this.get('value')) {
      this.$().val('');
      this.set('value', null);
      return false;
    }
  }
});