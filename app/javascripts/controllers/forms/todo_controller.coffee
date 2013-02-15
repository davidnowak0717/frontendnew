Autocomplete =
  lookup: (term) ->
    @contacts().find (contact) ->
      contact.get('name') is term

  contacts: -> Radium.Contact.all()

Radium.FormsTodoController = Ember.ObjectController.extend Radium.CurrentUserMixin,
  needs: ['users']
  users: Ember.computed.alias('controllers.users')

  submit: ->
    @set 'isSubmitted', true

  isExpandable: (->
    !@get('isNew') && !@get('isFinished')
  ).property('isNew', 'isFinished')

  isExpandableDidChange: (->
    if !@get('isExpandable') then @set('isExpanded', false)
  ).observes('isExpandable')

  isDisabled: (->
    @get('content.isEditable') is false
  ).property('isEditable')

  showCallBox: (->
    @get('isCall') && !@get('isNew')
  ).property('isCall', 'isNew')

  toggleExpanded: -> @toggleProperty 'isExpanded'

  expand: ->
    return unless @get('isExpandable')
    @toggleProperty 'isExpanded'

  hasComments: Radium.computed.isPresent('comments')
