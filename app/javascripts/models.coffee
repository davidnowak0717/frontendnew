require 'models/mixins/comments_mixin'
require 'models/mixins/attachments_mixin'
require 'models/mixins/timestamps_mixin'
require 'models/mixins/has_tasks_mixin'

Radium.PromiseProxy = Ember.ObjectProxy.extend Ember.PromiseProxyMixin,
  resolveContent: Ember.observer('promise', ->
    @then (result) => @set('content', result)
  ).on "init"

Radium.Model = DS.Model.extend Radium.TimestampsMixin,
  primaryKey: 'id'

  route: Ember.computed ->
    @store.container.lookup('route:application')

  delete:  ->
    self = this
    route = @get('route')

    new Ember.RSVP.Promise (resolve, reject) ->
      self.deleteRecord()

      self.one 'didDelete', ->
        resolve.call self

      self.one 'becameError', ->
        route.send 'flashError', 'An error has occured and the deletion could not be completed.'

        self.reset()

        reject.call self

      self.one 'becameInvalid', ->
        route.send 'flashError', self

        self.reset()

        reject.call self

      self.get('store').commit()

  save: ->
    self = this
    route = @get('route')

    new Ember.RSVP.Promise (resolve, reject) ->
      success = (result) ->
        resolve result

      self.one 'didCreate', success
      self.one 'didUpdate', success

      self.addErrorHandlers(reject)

      self.get('store').commit()

  addErrorHandlers: (reject) ->
    self = this
    route = @get('route')

    @one 'becameInvalid', (result) ->
      route.send 'flashError', result

      reject result

      Ember.run.next ->
        if self.get('id')
          self.reset()
        else
          result.reset()
          result.unloadRecord()

    @one 'becameError', (result) ->
      self.reset() if self.get('id')
      route.send 'flashError', 'An error has occurred and the operation could not be completed.'
      reject result

      return if result.get('id')

      Ember.run.next ->
        result.reset()
        result.unloadRecord()

  updateLocalBelongsTo: (key, belongsTo, notify = true) ->
    data = this.get('data')

    data[key] = {id: belongsTo.get('id'), type: belongsTo.constructor}

    @set('_data', data)

    return unless notify

    @suspendRelationshipObservers ->
      @notifyPropertyChange 'data'

    this.updateRecordArrays()

  updateHasMany: (key, newItemId, klass) ->
    Ember.assert "No newListId found to update local hasMany", newItemId

    data = @get('_data')
    store = @get('store')
    serializer = @get('store._adapter.serializer')
    loader = DS.loaderFor(store)

    references = data[key].map((item) -> {id: item.id, type: klass})

    item = Radium.List.all().find (t) -> t.get('id') == newItemId

    unless references.any((item) -> item.id == newItemId)
      references.push id: newItemId, type: klass

    references = @_convertTuplesToReferences(references)

    data[key] = references

    @set('_data', data)

    @suspendRelationshipObservers ->
      @notifyPropertyChange 'data'

    @updateRecordArrays()

  updateLocalProperty: (property, value, notify = true) ->
    data = this.get('data')

    data[property] = value

    @set('_data', data)

    return unless notify

    @suspendRelationshipObservers ->
      @notifyPropertyChange 'data'

  shallowCopy: ->
    self = this
    hash = {}

    @eachAttribute (key, meta) ->
      if val = self.get(key)
        hash[key] = val

    hash

  reload: ->
    return unless @get('inCleanState')

    @_super.apply this, arguments

  typeName: Ember.computed ->
    @constructor.toString().underscore().split('.').pop().toLowerCase()

  inErrorState: Ember.computed 'currentState.stateName', ->
    @get('currentState.stateName') == 'root.error'

  inCleanState: Ember.computed 'currentState.stateName', ->
    @get('currentState.stateName') == "root.loaded.saved"

  reset: ->
    state = if @get('id')
              "loaded.saved"
            else
              "loaded.created.uncommitted"

    @get('transaction').rollback()
    @transitionTo(state)
    @reload() if @get('id')

  deleteRecord: ->
    unless @get('inCleanState')
      return

    @send('deleteRecord')

  updatedEventKey: ->
    "#{@constructor.toString()}:#{@get('id')}:update"

  reloadAfterUpdateEvent: (event = 'didCreate') ->
    @one event, (result) ->
      @reloadAfterUpdate.call result

  reloadAfterUpdate: ->
    observer = ->
      if @get('inCleanState')
        @removeObserver 'currentState.stateName', observer
        @reload()

    @addObserver 'currentState.stateName', observer

  executeWhenInCleanState: (func) ->
    observer = =>
      return unless @get('inCleanState')

      @removeObserver 'currentState.stateName', observer

      func()

    if @get('inCleanState')
      observer()
    else
      @addObserver 'currentState.stateName', observer

requireAll /models/
