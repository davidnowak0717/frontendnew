Radium.EmailFormGroup = Ember.Mixin.create({
  insertNewline: function(event) {
    event.preventDefault();
    var val = this.get('value');
    if (val) {
      var nonSystemEmail = Ember.Object.create({
            email: val
          });
        this.getPath('selectedGroup.selected').addObject(nonSystemEmail);
      this.set('value', null);
    }
  },
  select: function(event, ui) {
    event.preventDefault();
    this.getPath('selectedGroup.selected').pushObject(ui.item.target);
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