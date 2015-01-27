Radium.CompaniesColumnConfig = Ember.Mixin.create
  fixedColumns: Ember.A([
    {
      classNames: "name"
      heading: "Name"
      route: "company"
      bindings: [{
        name: "model",
        value: "model"
      }
      {
        name: "placeholder",
        value: "Add Name",
        static: true
      },
      {
        name: "bufferKey",
        value: "name"
        static: true
      }]
      avatar: true
      checked: true
      sortOn: "name"
      component: 'editable-field'
    }
  ])

  columns: Ember.A([
    {
      id: "open-deals"
      classNames: "open-deals"
      heading: "Open Deals"
      binding: "openDeals"
      sortOn: "open_deals"
      initialDesc: true
    }
    {
      id: "assign"
      classNames: "assign"
      heading: "Assigned To"
      component: "assignto-picker"
      bindings: [
        {name: "assignedTo", value: "assignedTo"},
        {name: "assignees", value: "assignees"},
        {name: "model", value: "model"},
      ]
    }]
  )
