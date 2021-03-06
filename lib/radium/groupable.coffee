Radium.Groupable = Em.Mixin.create
  groupType: Ember.ArrayProxy

  contentArrayDidChange: (array, idx, removedCount, addedCount) ->
    addedObjects = array.slice(idx, idx + addedCount)
    for object in addedObjects
      group = @groupFor object
      group.get('content').pushObject object unless group.get('content').contains object
      groups = @get 'groups'
      unless groups.contains group
        groups.pushObject group

    @_super array, idx, removedCount, addedObjects

  contentArrayWillChange: (array, idx, removedCount, addedCount) ->
    removedObjects = array.slice(idx, idx + removedCount)
    for object in removedObjects
      group = @groupFor object
      group.get('content').removeObject object
      if group.get('content.length') == 0
        @get('groups').removeObject group

    @_super.apply(this, arguments)

  groupedContent: Ember.computed 'arrangedContent', ->
    if content = @get 'arrangedContent'
      @group(content)

  group: (collection) ->
    groupsMap = {}
    groups    = Ember.A([])
    @set 'groupsMap', groupsMap
    @set 'groups',    groups

    collection.forEach ((object) ->
      group = @groupFor(object)
      return unless group

      group.get("content").pushObject object
    ), this

    groups

  groupFor: (object) ->
    groupsMap = @get 'groupsMap'

    unless groupsMap
      groupsMap = {}
      @set 'groupsMap', groupsMap

    groups    = @get 'groups'

    unless groups
      groups = Ember.A([])
      @set 'groups', groups

    groupName = @groupBy(object)
    return unless groupName

    group = groupsMap[groupName]
    unless group
      groupType = @get 'groupType'
      group = groupType.create content: Ember.A([]), name: groupName
      groupsMap[groupName] = group
      groups.pushObject group

    group
