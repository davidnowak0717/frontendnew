Radium.AddressbookUntrackedRoute = Radium.Route.extend
  actions:
    track: (contact) ->
      track = Radium.TrackedContact.createRecord
                contact: contact

      track.one 'didCreate', (result) =>
        @send "flashSuccess", "Contact is now tracked in Radium"
        @dataset.removeObject(contact)
        @controllerFor('addressbook').send 'updateTotals'

      @store.commit()

    loadMoreContacts: ->
      @dataset.expand()

    destroyContact: (contact)->
      contact.deleteRecord()
      contact.one 'didDelete', =>
        @send "flashSuccess", "Contact deleted"
        @dataset.removeObject contact
        @controllerFor('addressbook').send 'updateTotals'

      @store.commit()

  model: ->
    @dataset = Radium.InfiniteDataset.create
      type: Radium.Contact
      params: {private: true}