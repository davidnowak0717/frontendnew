Radium.Route = Ember.Route.extend()

Radium.Router.reopen
  location: 'history'
  didTransition: (infos) ->
    @_super.apply this, arguments
    numberOfContacts =  Radium.Contact.all().filter((contact) -> not contact.get('isPersonal')).get('length')
    window.Intercom('update', number_of_contacts: numberOfContacts)
    window.Intercom('reattach_activator')

  eventBus: Ember.computed ->
    @container.lookup('event-bus:current')

Radium.Router.map ->
  @resource 'messages', path: '/messages/:folder', ->
    @route 'bulk_actions'
    @resource 'emails', ->
      @route 'show', path: '/:email_id'
      @route 'thread', path: '/:email_id/thread'
      @route 'empty', path: '/empty'
      @route 'new'
      @route 'edit', path: '/:email_id/edit'
      @route 'sent', path: '/:email_id/sent'
    @resource 'templates', ->
      @route 'new', path: '/new'
      @route 'edit', path: '/:template_id/edit'

  @resource 'conversations', path: '/conversations/:type'

  @resource 'leads', ->
    @route 'new'
    @route 'single'
    @route 'import'
    @route 'match'
    @route 'fromCompany', path: '/new/companies/:company_id'

  @resource 'contacts'
  @resource 'contact', path: '/contacts/:contact_id'

  @resource 'lists'
  @resource 'list', path: '/lists/:list_id'

  @resource 'company', path: '/companies/:company_id'

  @resource 'user', path: '/users/:user_id', ->
    @route 'form', path: '/:form'

  @resource 'deals', ->
    @resource 'deal', path: '/:deal_id'
    @route 'new'
    @route 'fromContact', path: '/new/contacts/:contact_id'
    @route 'fromUser', path: '/new/users/:user_id'
    @route 'fromCompany', path: '/new/companies/:company_id'

  @resource 'calendar', ->
    @route 'index', path: '/:year/:month/:day'
    @route 'task', path: '/:task_type/:task_id'

  @resource 'addressbook', ->
    @resource 'people', ->
      @route 'contacts'
      @route 'index', path: '/:filter'
    @route 'companies'
    @route 'contactimportjobs', path: '/contactimportjobs/:contact_import_job_id/contacts'

  @resource 'settings', ->
    @route 'profile'
    @route 'company'
    @route 'billing'
    @route 'general'
    @route 'mail'
    @route 'api'
    @route 'customFields', path: 'custom-fields'
    @route 'leadSources', path: 'lead-sources'
    @route 'contactStatuses', path: 'contact-statuses'
    @route 'listStatuses', path: 'list-statuses'
    @route 'remindersAlerts', path: 'reminders-alerts'

  @route 'reports'

  @route 'unimplemented'
