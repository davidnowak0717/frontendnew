require 'lib/radium/aggregate_array_proxy'

Radium.CreateMeeting = Radium.Model.extend
  meeting: DS.belongsTo 'Radium.Meeting'
  invitations: DS.attr('array')

  topic: DS.attr('string')
  location: DS.attr('string')
  startsAt: DS.attr('datetime')
  endsAt: DS.attr('datetime')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = value.constructor.toString().split('.')[1]
      associationName = "_reference#{property}"
      @set associationName, value
    else
      @get('_referenceTodo') || @get('_referenceEmail')
  ).property('_referenceEmail', '_referenceTodo')
  _referenceEmail: DS.belongsTo('Radium.Email')
  _referenceTodo: DS.belongsTo('Radium.Todo')

  time: Ember.computed.alias('startsAt')
