Radium.SettingsProfileController = Radium.ObjectController.extend BufferedProxy,
  actions:
    save: (user) ->
      unless @hasBufferedChanges
        @set 'isEditing', false
        @applyBufferedChanges()
        return

      @set 'isSubmitted', true

      return unless @get('isValid')

      @applyBufferedChanges()

      user = @get('model')

      user.one 'didUpdate', =>
        @set 'isEditing', false
        @send "flashSuccess", "Profile settings saved!"

      user.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      user.one 'becameError', (result) =>
        @send 'flashError', "an error happened and the profile could not be updated"
        @resetModel()

      user.get('settings').one 'didUpdate', =>
        @send 'flashSuccess', 'Signature updated'

      user.get('transaction').commit()

      @discardBufferedChanges()
      false

    cancel: (user) ->
      @set 'isSubmitted', false
      @discardBufferedChanges()
      false

    toggleEdit: ->
      @toggleProperty('isEditing')
      false

    toggleAvatar: ->
      @toggleProperty('isEditingAvatar')
      false

  needs: ['userSettings']
  settings: Ember.computed.alias 'controllers.userSettings'
  signatureBinding: 'controllers.userSettings.signature'

  isEditing: false
  isEditingAvatar: false

  isValid: Ember.computed 'firstName', 'lastName', ->
    !Ember.isEmpty(@get('firstName')) && !Ember.isEmpty(@get('lastName'))
