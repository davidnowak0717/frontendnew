Radium.NotificationsController = Ember.ArrayController.extend Radium.Groupable,
  isVisible: false

  count: (->
    messages = @get('messages.length') || 0
    reminders = @get('reminders.length') || 0
    messages + reminders + @get('length')
  ).property('messages.length', 'reminders.length', 'length')

  toggleNotifications: (event) ->
    @toggleProperty 'isVisible'
    false

  dismiss: (event) ->
    item = event.view.content
    @destroyItem item

  dismissAll: (event) ->
    collection = event.context
    # toArray() needs to be used to 'materialize' array and
    # not use RecordArray, otherwise, when we get to last item
    # it will already by null
    collection.toArray().forEach (item) ->
      item.deleteRecord()

    @get('store').commit()

  destroyItem: (item) ->
    item.deleteRecord()
    @get('store').commit()

  groupBy: (item) ->
    item.get('referenceType')

  groupType: Em.ArrayProxy.extend
    humanName: (->
      groupId = @get('groupId')
      groupId.humanize().capitalize().pluralize()
    ).property('groupId')
