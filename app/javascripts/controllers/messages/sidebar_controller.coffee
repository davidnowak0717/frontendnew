Radium.MessagesSidebarController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  actions:
    refresh: ->
      return if @get('cannotRefresh') || @get('isSyncing')

      currentUser = @get('currentUser')

      job = Radium.EmailSyncJob.createRecord
              user: currentUser

      job.one 'didCreate', (result) =>
        currentUser.reload()

        currentUser.one 'didReload', =>
          refreshPoller = @get('refreshPoller')

          refreshPoller.set 'controller', this

          refreshPoller.start()

      job.one 'becameInvalid', (result) =>
        @set 'isSyncing', false
        @send 'flashError', job

      job.one 'becameInvalid', (result) =>
        @set 'isSyncing', false
        @send 'flashError', 'An error has occurred and the refresh command failed'

      @set 'isSyncing', true

      @get('store').commit()

    checkMessageItem: ->
      currentPath = @get('currentPath')
      model = @get('model.model')

      predicate = (item) ->
                    !item.get('isDeleted') && !item.get('isChecked')

      if model.filterProperty('isChecked').get('length')
        return if currentPath == 'messages.bulk_actions'
        @transitionToRoute 'messages.bulk_actions'
      else if currentPath == 'messages.bulk_actions'
        first = model.filter(predicate)?.get('firstObject')
        @send 'selectItem', first

    loadInitialPages: ->
      return if @get('searchIsActive')
      return if @get('page') > 1 && @get('currentUser.initialMailImported')

      meta = @get('store').typeMapFor(Radium.Email).metadata

      Ember.run.next =>
        @set('totalRecords', meta.totalRecords)
        @set('allPagesLoaded', meta.allPagesLoaded)

      pageSize = @get('controllers.messages.pageSize')

      if meta.totalRecords > pageSize
        for i in [0...3]
          currentCount = (i + 1) * pageSize
          @send 'showMore' if meta.totalRecords >= currentCount

    reset: ->
      @set('page', 1)
      @set('allPagesLoaded', false)
      @set('isLoading', false)

    toggleSearch: ->
      @toggleProperty 'isSearchOpen'

  needs: ['messages', 'emailsThread']

  init: ->
    @_super.apply this, arguments
    @set 'refreshPoller', Radium.RefreshPoller.create()

  cannotRefresh: Ember.computed 'folder.length', ->
    @get('folder') != 'inbox'

  modelQuery: ->
    requestParams = Ember.merge(@get('controllers.messages').requestParams(), page: @get('page'))

    Radium.Email.find(requestParams)

  isSearchOpen: false

  page: 1
  allPagesLoaded: false
  loadingType: Radium.Email

  currentPath: Ember.computed.oneWay 'controllers.application.currentPath'
  model: Ember.computed.oneWay 'controllers.messages'
  selectedContent: Ember.computed.oneWay 'controllers.messages.selectedContent'
  totalRecords: Ember.computed.oneWay 'controllers.messages.model.totalRecords'
  folder: Ember.computed.oneWay 'controllers.messages.folder'
  itemController: 'messagesSidebarItem'

  inboxIsActive: Ember.computed 'folder', ->
    folders = @get('controllers.messages.folders').mapProperty 'name'
    folders.contains @get('folder')

  radiumIsActive: Ember.computed.equal('folder', 'radium')
  searchIsActive: Ember.computed.equal('folder', 'search')

  isSyncing: false
