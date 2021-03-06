Radium.PeopleMixin = Ember.Mixin.create Ember.Evented,
  Radium.CheckableMixin,
  actions:
    makePublicAll: ->
      detail =
        jobType: Radium.BulkActionsJob
        modelType: Radium.Contact
        public: false
        private: true

      @send "executeActions", "make_public", detail
      false

    showMore: ->
      return if @get('content.isLoading')
      @get('model').expand()

      false

    switchShared: (contact) ->
      Ember.run.next =>
        contact.toggleProperty('isPublic')

        unless contact.get('isPublic')
          contact.set "potentialShare", true

        contact.save().then =>
          @send 'updateTotals'

      false

    sort: (prop, ascending) ->
      model = @get("model")
      params = model.get("params")

      delete params.sort_properties
      sort_properties = "sort_properties": JSON.stringify([{"property": prop, "asc": ascending}])

      params = Ember.merge sort_properties, params

      model.set 'params', params
      false

    executeActions: (action, detail) ->
      checkedContent = @get('checkedContent')

      allChecked = if @get('isQuery')
                      @get('allChecked')
                   else
                      @get('allChecked') && !!!@get('potentialQueries.length')

      unless allChecked || checkedContent.length
        return @flashMessenger.error "You have not selected any items."

      if action == "compose"
        return @transitionToRoute 'emails.new', "inbox", queryParams: mode: 'bulk', from_people: true

      @set 'working', true

      unless allChecked
        ids = checkedContent.mapProperty('id')
        filter = null
      else
        ids = []
        filter = @get('filter')

      job = detail.jobType.createRecord
             action:  action
             ids: ids
             public: @get('public')
             private: @get('private')
             filter: filter


      searchText = $.trim(@get('searchText') || '')

      if searchText.length
        job.set 'like', searchText

      if action == "list"
        job.set('newLists', Ember.A([detail.list.id]))
      else if action == "assign"
        job.set('assignedTo', detail.user)
      else if action == "status"
        job.set('status', detail.status)

      if @get("isQuery")
        Ember.assert "you must have a customquery for an isQuery", @get('customquery')
        job.set 'customquery', @get('customquery')

      if @get('list') && @get('isListed')
        list = Radium.List.all().find (t) => t.get('id') == @get('list')
        job.set('list', list)

      if @get('user') && @get('isAssignedTo')
        user = Radium.User.all().find (u) => u.get('id') == @get('user')
        job.set 'user', user

      job.save().then( (result) =>
        if job.get('exportToCsvJob')
          @flashMessenger.success "The export job has been created and you will shortly be emailed the results of the export."
          return

        @flashMessenger.success 'The records have been updated.'
        Ember.run.once this, 'updateLocalRecords', job, detail
        @send 'updateTotals'
        @get('currentUser').reload()
      ).finally =>
        @set 'working', false

  updateLocalRecords: (job, detail) ->
    ids = @get('checkedContent').mapProperty 'id'
    action = job.get('action')
    dataset = @get('model')

    for id in ids by -1
      model = detail.modelType.all().find (c) -> c.get('id') + '' == id + ''

      if model
        if action == "delete"
          local = "localDelete"
          args = [model, dataset]
        else
          if action.indexOf('_') > 1
            parts = action.split('_')
            action = "#{parts[0]}#{parts[1].capitalize()}"

          local = "local#{action.capitalize()}"
          args = [model, job]

        this[local].apply this, args

    if addressBookController = @get('controllers.addressbook')
      addressBookController.send 'updateTotals'

  localMakePublic: (contact, dataset) ->
    contact.set 'isChecked', false
    Ember.run.next =>
      @get('model').removeObject contact

  localDelete: (model, dataset) ->
    dataset.removeObject model
    model.unloadRecord()

  localAssign: (model, job) ->
    model.updateLocalBelongsTo 'user', job.get('assignedTo')

  localStatus: (model, job) ->
    model.updateLocalBelongsTo 'contactStatus', job.get('status')

  localList: (model, job) ->
    model.updateHasMany('lists', job.get('newLists.firstObject'), Radium.List)

  users: Ember.computed.oneWay 'controllers.users'

  totalRecords: Ember.computed 'content.source.content.meta', ->
    @get('content.source.content.meta.totalRecords')

  checkedTotal: Ember.computed 'totalRecords', 'checkedContent.length', 'allChecked', 'working', ->
    if @get('allChecked')
      @get('totalRecords')
    else
      @get('checkedContent.length')

  searchText: ""

  searchDidChange: Ember.observer "searchText", ->
    Ember.run.debounce this, @likeNessQuery, 300

  likeNessQuery: ->
    return if @get('filter') is null

    searchText = @get('searchText')

    filterParams = @get('filterParams') || {}

    params = Ember.merge filterParams, like: searchText, public: @get('public'), private: @get('private'), page_size: @get('pageSize')

    @get("content").set("params", Ember.copy(params))

  pageSize: 25
