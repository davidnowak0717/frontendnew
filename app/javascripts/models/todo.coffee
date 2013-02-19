typeMap = Ember.Map.create()

typeMap.set 'Radium.Discussion', 'discussion'
typeMap.set 'Radium.Deal', 'deal'
typeMap.set 'Radium.Email', 'email'
typeMap.set 'Radium.Todo', 'todo'

Radium.Todo = Radium.Model.extend Radium.CommentsMixin,
  Radium.AttachmentsMixin,

  user: DS.belongsTo('Radium.User')

  kind: DS.attr('string')
  description: DS.attr('string')
  finishBy: DS.attr('datetime')
  isFinished: DS.attr('boolean')

  contact: DS.belongsTo('Radium.Contact')
  deal: DS.belongsTo('Radium.Deal')
  email: DS.belongsTo('Radium.Email')
  todo: DS.belongsTo('Radium.Todo')

  reference: ((key, value) ->
    if arguments.length == 2 && value != undefined
      property = typeMap.get value.constructor.toString()
      @set property, value
    else
      @get('contact') || @get('deal') || @get('email')
  ).property('contact', 'deal', 'email')

  # FIXME: this should be a computed property
  overdue: DS.attr('boolean')

  time: Ember.computed.alias('finishBy')

  # TODO: replace with a computed alias
  isCall: ( ->
    (if (@get('kind') is 'call') then true else false)
  ).property('kind')

  # TODO: replace with a computed alias
  isDueToday: ( ->
    today = Ember.DateTime.create()
    finishBy = @get('finishBy')
    Ember.DateTime.compareDate(today, finishBy) is 0
  ).property('finishBy')
