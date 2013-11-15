Radium.ExternalcontactsController = Radium.ArrayController.extend Radium.InfiniteScrollControllerMixin,
  needs: ['addressbook']
  page: 1
  allPagesLoaded: false
  pageSize: 20
  loadingType: Radium.ExternalContact

  categories: Ember.computed.alias 'controllers.addressbook.categories'
  searchText: null

  actions:
    promote: (model, status) ->
      promote = Radium.PromoteExternalContact.createRecord
                externalContact: model
                status: status

      existingDeals = Radium.Deal.all().slice()

      promote.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact created!"
        @get('content').removeObject(model)
        if status == "pipeline" 
          Radium.Deal.find({}).then (deals) =>
            delta = deals.toArray().reject (record) =>
                      existingDeals.contains(record)

            deal = delta.get('firstObject')
            @get('controllers.addressbook.model').pushObject(deal.get('contact'))
            @set 'newPipelineDeal', deal

      @get('store').commit()

    showMore: ->
      return false if @get('searchText.length')
      @_super.apply this, arguments
      false

    reset: ->
      @set('model', Ember.A())
      @set('page', 1)
      @send 'showMore'

  modelQuery: ->
    Radium.ExternalContact.find(@queryParams())

  queryParams: ->
    pageSize = @get('pageSize')
    userId = @get('currentUser.id')
    page = @get('page')

    page: page
    page_size: pageSize
    user_id: userId

  arrangedContent: ( ->
    return unless @get('content.length')

    @get('content').filter (item) -> item.get('name.length') || item.get('email.length')
  ).property('content.[]')

  hasNewPipelineDeal: ( ->
    @get('newPipelineDeal')
  ).property('newPipelineDeal')

  isLoading: false

  searchTextDidChange: ( ->
    searchText = @get('searchText')

    unless searchText.length
      @send 'reset'
      return

    return unless searchText?.length > 1

    @set('isLoading', true)

    Radium.AutocompleteItem.find(scopes: 'external_contact', term: searchText).then (results) =>
      unless results.get('length')
        @set('content', Ember.A())

      people = Ember.A(results.map (result) -> result.get('person'))

      @set('content', Ember.A())
      @set("content", people)
      @set('isLoading', false)
  ).observes('searchText')