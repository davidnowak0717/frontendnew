Radium.Router.reopen
  location: 'history'

# renderTemplate: function() {
#   this.render('myPost', {   // the template to render
#     into: 'index',          // the template to render into
#     outlet: 'detail',       // the name of the outlet in that template
#     controller: 'blogPost'  // the controller to use for the template
#   });
# }

DrawerSupport = Ember.Mixin.create
  toggleDrawer: (name) ->
    if @get('router.openDrawer') == name
      # FIXME: find a way to disconnect this
      @render 'nothing', into: 'drawer_panel'
      @set 'router.openDrawer', null
    else
      @render name, into: 'drawer_panel'
      @set 'router.openDrawer', name

  closeDrawer: ->
    @render 'nothing', into: 'drawer_panel'
    @set 'router.openDrawer', null


Radium.ApplicationRoute = Ember.Route.extend DrawerSupport,
  events:
    toggleDrawer: (name) ->
      @toggleDrawer name

  renderTemplate: ->
    @render()
    @render 'drawer_panel', outlet: 'drawerPanel'

Radium.DashboardRoute = Ember.Route.extend
  renderTemplate: ->
    @render 'unimplemented'

Radium.EmailsRoute = Ember.Route.extend DrawerSupport,
  events: 
    selectFolder: (name) ->
      @controllerFor('emails').set 'folder', name
      @closeDrawer()

    toggleFolders: ->
      @toggleDrawer 'emails/folders'

    selectContent: (item) ->
      @controllerFor('emails').set 'selectedContent', item

  model: (params) ->
    Radium.Email.find folder: 'inbox'

  renderTemplate: ->
    # FIXME this seems wrong. It uses drawer_panel for
    # some reason. This seems like an Ember bug
    @render into: 'application'

    @render 'emails/sidebar', 
      into: 'emails'
      outlet: 'sidebar'

    @render 'emails/drawer_buttons'
      into: 'drawer_panel'
      outlet: 'buttons'

Radium.Router.map ->
  @route 'dashboard'
  @route 'emails', path: '/messages'
