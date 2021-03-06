Radium.MeetingAttendeeItemController = Radium.ObjectController.extend
  actions:
    cancelInvitation: (attendee) ->
      invitation = @findInviationFromAttendee attendee
      Ember.assert "No invitation found for attendee #{attendee.get('id') - attendee.constructor}", invitation

      name = invitation.get('person.displayName')

      invitation.delete().then =>
        @send 'flashSuccess', "#{name} has been removed from this meeting"

    resendInvite: (attendee) ->
      alert 'No server side implementation yet'

  isOrganizer: Ember.computed 'person', 'parentController.organizer', ->
    @get('model') == @get('parentController.organizer')

  invited: Ember.computed.alias 'parentController.invited'
  isNew: Ember.computed.alias 'parentController.isNew'

  title: Ember.computed 'displayName', 'isLoaded', ->
    return "loading...." unless @get('isLoaded')

    title = @get('displayName')

    unless @get('isOrganizer')
      title += " - #{@get('invitationStatus')}" unless @get('isNew')
    else
      title += " - organizer"

    title

  displayStatus: Ember.computed 'isOrganizer', 'isNew', ->
    !@get('isOrganizer') && !@get('isNew')

  invitationStatus: Ember.computed 'model', ->
    @findInviationFromAttendee(@get('model')).get('status')

  isInvited: Ember.computed 'model', 'invited.[]', ->
    return true if @get('isOrganizer')
    @get('invited').contains(@get('model'))

  findInviationFromAttendee: (attendee) ->
    @get('parentController.invitations').find (invitation) =>
      invitation.get("person") == attendee
