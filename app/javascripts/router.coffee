Radium.Router = Ember.Router.extend
  location: 'history'
  enableLogging: true
  initialState: 'loading'

  showUser: Ember.Route.transitionTo('root.users.user')
  showContacts: Ember.Route.transitionTo('root.contacts')
  showContact: Ember.Route.transitionTo('root.contacts.contact')
  showDeal: Ember.Route.transitionTo('root.deal')
  showCampaign: Ember.Route.transitionTo('root.campaigns.campaign')
  showGroup: Ember.Route.transitionTo('root.groups.group')
  showDashboard: Ember.Route.transitionTo('root.dashboard')
  setFilter: Ember.Route.transitionTo('root.dashboard.byType')

  jumpTo: (query) ->
    query   ?= {}

    sections = Radium.store.expandableArrayFor Radium.FeedSection
    sections.load Radium.FeedSection.find(query)

    if query.type
      plural = query.type.pluralize()
      type   = Radium["#{query.type.camelize().capitalize()}FeedSection"]

      @get('mainController').connectOutlet('content', "#{plural}Feed", sections)
      Radium.router.set("#{plural}FeedController.recordId", query.id)
      Radium.router.set("#{plural}FeedController.recordType", type)
      Radium.router.set("#{plural}FeedController.type", query.type)
    else
      @get('mainController').connectOutlet('content', 'feed', sections)

    unless query.disableScroll
      Radium.Utils.scrollWhenLoaded(sections, "feed_section_#{query.date}")

  init: ->
    @_super()

    @set('meController', Radium.MeController.create())

  loading: Ember.Route.extend
    # overwrite routePath to not allow default behavior
    # Ember.Router does not support cancelling routing, which prevents
    # from doing authentication easily - if a user hits url, it will
    # go there by default. We need to overwrite this behavior to check
    # authentication and then redirect to correct state
    # TODO: fix when ember is updated
    routePath: (router, path) ->
      router.set('lastAttemptedPath', path)
      router.get('meController').fetch()

  switchToUnauthenticated: Ember.State.transitionTo('unauthenticated.index')
  switchToAuthenticated: Ember.State.transitionTo('authenticated.index')

  unauthenticated: Ember.Route.extend
    index: Ember.Route.extend
      route: '/'

      connectOutlets: (router) ->
        router.transitionTo('login')

    login: Ember.Route.extend
      route: '/login'

      connectOutlets: (router) ->
        router.get('applicationController').connectOutlet('login')

  root: Ember.Route.extend
    connectOutlets: (router) ->
      usersController = Radium.UsersController.create()
      usersController.set 'content', Radium.store.findAll(Radium.User)
      router.set 'usersController', usersController

      router.get('applicationController').connectOutlet('main')
      router.get('applicationController').connectOutlet('sidebar', 'sidebar')
      router.get('applicationController').connectOutlet('topbar', 'topbar')

    dashboard: Ember.Route.extend
      route: '/'
      connectOutlets: (router) ->
        router.jumpTo()

      all: Ember.Route.extend
        route: '/'
        connectOutlets: (router) ->
          router.get('feedController').set('typeFilter', null)

      byType: Ember.Route.extend
        route: '/type/:type'
        connectOutlets: (router, type) ->
          if type != 'all'
            router.get('feedController').set('typeFilter', type)
          else
            router.transitionTo('root.dashboard.all')

        # FIXME: for some weird reason, there is no url for this route,
        #        even though I use href=true
        serialize: (router, type) ->
          {type: type}

        deserialize: (router, params) ->
          params.type

    # TODO: find out what's the best pattern to handle such things
    dashboardWithDate: Ember.Route.extend
      route: '/dashboard/:date'
      connectOutlets: (router, params) ->
        router.jumpTo(params)

    deal: Ember.Route.extend
      route: '/deals/:deal_id'
      connectOutlets: (router, deal) ->
        router.get('mainController').connectOutlet('content', 'deal', deal)

      deserialize: (router, params) ->
        params.deal_id = parseInt(params.deal_id)

    campaigns: Ember.Route.extend
      route: '/campaigns'

      campaign: Ember.Route.extend
        route: '/:campaign_id'
        connectOutlets: (router, campaign) ->
          router.get('mainController').connectOutlet('content', 'campaign', campaign)

        deserialize: (router, params) ->
          params.campaign_id = parseInt(params.campaign_id)

    groups: Ember.Route.extend
      route: '/groups'

      group: Ember.Route.extend
        route: '/:group_id'
        connectOutlets: (router, group) ->
          router.get('mainController').connectOutlet('content', 'group', group)

        deserialize: (router, params) ->
          params.group_id = parseInt(params.group_id)

    contacts: Ember.Route.extend
      route: '/contacts'
      connectOutlets: (router) ->
          router.get('mainController').connectOutlet('content', 'contacts')

      contact: Ember.Route.extend
        route: '/:contact_id'
        connectOutlets: (router, contact) ->
          router.jumpTo(type: 'contact', id: contact.get('id'))

        deserialize: (router, params) ->
          params.contact_id = parseInt(params.contact_id)
          @_super(router, params)

    users: Ember.Route.extend
      route: '/users'

      user: Ember.Route.extend
        route: '/:user_id'
        connectOutlets: (router, user) ->
          router.jumpTo(type: 'user', id: user.get('id'))

        deserialize: (router, params) ->
          # fixture adapter is pretty limited and works only with integer ids
          # TODO: check if ember always assumes that id has integer type
          params.user_id = parseInt(params.user_id)
          @_super(router, params)

  authenticated: Ember.Route.extend
    index: Ember.Route.extend
      connectOutlets: (router) ->
        router.transitionTo('root')

        path = router.get('lastAttemptedPath')
        if path && path != '/'
          router.route(path)
