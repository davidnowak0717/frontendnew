Radium.Contact = Radium.Model.extend Radium.FollowableMixin,
  Radium.HasTasksMixin,

  todos: DS.hasMany('Radium.Todo')
  calls: DS.hasMany('Radium.Call', inverse: 'contact')
  meetings: DS.hasMany('Radium.Meeting', inverse: '_referenceContact')
  deals: DS.hasMany('Radium.Deal')
  followers: DS.hasMany('Radium.User', inverse: 'contacts')
  tags: DS.hasMany('Radium.Tag')
  tagNames: DS.hasMany('Radium.TagName')
  activities: DS.hasMany('Radium.Activity', inverse: 'contacts')
  phoneNumbers: DS.hasMany('Radium.PhoneNumber')
  emailAddresses: DS.hasMany('Radium.EmailAddress')
  addresses: DS.hasMany('Radium.Address')

  user: DS.belongsTo('Radium.User')
  company: DS.belongsTo('Radium.Company', inverse: 'contacts')

  contactInfo: DS.belongsTo('Radium.ContactInfo')

  name: DS.attr('string')
  companyName: DS.attr('string')
  status: DS.attr('string')
  source: DS.attr('string')
  status: DS.attr('string')
  title: DS.attr('string')
  avatarKey: DS.attr('string')
  notes: DS.attr('string')

  isPersonal: Ember.computed.equal 'status', 'personal'
  isPublic: Ember.computed.not 'isPersonal'

  isExpired: Radium.computed.daysOld('createdAt', 60)

  latestDeal: ( ->
    # FIXME: Is it safe to assume that
    #deals will be ordered on the server?
    @get('deals.firstObject')
  ).property('deals')

  tasks: Radium.computed.tasks('todos', 'calls', 'meetings')

  isLead: Ember.computed.equal 'status', 'pipeline'

  isPersonal: ( ->
    @get('status') == 'personal'
  ).property('status')

  isExcluded: ( ->
    @get('status') == 'exclude'
  ).property('status')

  primaryEmail: Radium.computed.primary 'emailAddresses'
  primaryPhone: Radium.computed.primary 'phoneNumbers'
  primaryAddress: Radium.computed.primary 'addresses'

  email: Ember.computed.alias 'primaryEmail.value'

  openDeals: ( ->
    @get('deals').filterProperty 'isOpen'
  ).property('deals.[]')

  displayName: ( ->
    @get('name') || @get('primaryEmail.value') || @get('primaryPhone.value')
  ).property('name', 'primaryEmail', 'primaryPhone')

  nameWithCompany: ( ->
    if @get('company.name')
      "#{@get('name')} (#{@get('company.name')})"
    else
      @get('name')
  ).property('name', 'company.name')

  clearRelationships: ->
    @get('deals').forEach (deal) =>
      deal.deleteRecord()

    @get('tasks').forEach (task) =>
      task.deleteRecord()

    @get('activities').compact().forEach (activity) =>
      activity.deleteRecord()
