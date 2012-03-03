Radium.DateFilterView = Ember.View.extend({
  templateName: 'feed_date_filters', 
  dateTypesView: Ember.CollectionView.extend({
    tagName: 'ul',
    content: [
      Ember.Object.create({label: "Daily", type: "day"}),
      Ember.Object.create({label: "Weekly", type: "week"}),
      Ember.Object.create({label: "Monthly", type: "month"}),
      Ember.Object.create({label: "Quarterly", type: "quarter"}),
      Ember.Object.create({label: "Yearly", type: "year"})
    ],
    itemViewClass: Ember.View.extend({
      isSelected: function() {
        return (this.getPath('parentView.parentView.dateFilter') === this.getPath('content.type')) ?
                true : false;
      }.property('parentView.parentView.dateFilter').cacheable(),
      classNameBindings: ['isSelected:active'],
      changeFilter: function(view, event, context) {
        var filterType = this.getPath('content.type');
        this.setPath('parentView.parentView.dateFilter', filterType);
        Radium.App.goToState('load');
        
        // Blur out the datepicker
        $('#date-ranges').next().find('input').val('');
        return false;
      },
      template: Ember.Handlebars.compile('<a href="#" {{action "changeFilter"}}>{{content.label}}</a>')
    })
  }),

  // DatePicker
  datePicker: Radium.DatePickerField.extend({
    classNames: ["span2"],
    value: null,
    change: function() {
      var date = this.$().val();
      Radium.App.send('selectDate', date);
    }
  })
});