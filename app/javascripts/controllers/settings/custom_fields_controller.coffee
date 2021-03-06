Radium.SettingsCustomFieldsController = Ember.ArrayController.extend
  actions:
    createCustomField: (customField) ->
      model = @get('model')

      index = model.indexOf customField

      model.removeObject(customField)

      newRecord = Radium.CustomField.createRecord(customField.toHash())

      newRecord.save().then (result) =>
        model.insertAt index, newRecord
        @send 'flashSuccess', 'Custom Field Saved.'

      @get('model').pushObject(Ember.Object.create(isNew: true, type: 'text'))

      all = Radium.Contact.all()

      setTimeout ->
        all.forEach (c) -> c.set('customFieldMap', null) if c.get('customFieldMap')
      , 0

      false

    updateCustomField: (customField) ->
      customField.save().then (result) =>
        @send 'flashSuccess', 'Custom Field Saved.'

    addNewCustomField: ->
      customField = Ember.Object.create isNew: true, type: 'text'
      @get('model').addObject customField

    removeCustomField: (customField) ->
      isNew = customField.get('isNew')

      remove = =>
        @get('model').removeObject customField
        customField.unloadRecord() unless isNew
        @send('flashSuccess', 'field deleted') unless isNew

      return remove() if isNew

      customField.delete().then remove

  lastItem: Ember.computed.oneWay 'model.lastObject'

  isSubmitted: false
