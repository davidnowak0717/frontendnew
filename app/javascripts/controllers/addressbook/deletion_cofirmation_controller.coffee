Radium.PeopleDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.peopleIndex').send 'deleteAll'

  needs: ['peopleIndex']

  checkedTotal: Ember.computed.alias 'controllers.peopleIndex.checkedTotal'

Radium.AddressbookDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.addressbookCompanies').send 'deleteAll'

  needs: ['addressbookCompanies']

  checkedTotal: Ember.computed.alias 'controllers.addressbookCompanies.checkedTotal'

Radium.LeadsDeletionConfirmationController = Radium.ObjectController.extend
  actions:
    deleteAll: ->
      @send 'close'
      @get('controllers.untrackedIndex').send 'deleteAll'

  needs: ['untrackedIndex']

  checkedTotal: Ember.computed.alias 'controllers.untrackedIndex.checkedTotal'

