Radium.EmailsShowController = Radium.ObjectController.extend Radium.ChangeContactStatusMixin,
  actions:
    changeStatus: (email, newStatus) ->
      email.set('isPersonal', false)

      email.one 'didUpdate', (result) =>
        @send "flashSuccess", "email has been made public"

      email.one 'becameInvalid', (result) =>
        @send 'flashError', result
        @resetModel()

      email.one 'becameError', (result) =>
        @send 'flashError', "an error happened and the profile could not be updated"
        @resetModel()

      @_super.call(this, newStatus)

    dismissExtension: ->
      @set 'currentUser.settings.alerts.extensionSeen', true
      @get('store').commit()


  activeDeal: Ember.computed.alias('contact.deals.firstObject')
  nextTask: Ember.computed.alias('contact.nextTask')
  showExtensionCTA: Ember.computed.not 'currentUser.settings.alerts.extensionSeen'

  contact: ( ->
    sender = @get('sender')

    return sender if sender instanceof Radium.Contact
  ).property('sender')

  showHud: (->
    !Ember.isNone(@get('contact'))
  ).property('contact')
