Radium.EmailsItemController = Radium.ObjectController.extend Radium.AttachedFilesMixin,
  Radium.EmailDealMixin,
  actions:
    toggleFormBox: ->
      @toggleProperty 'showFormBox'
      return

    showForm: (form) ->
      @setProperties
        showFormBox: true
        currentForm: form

      @set 'formBox.activeForm', form
      return

    toggleMeta: ->
      @toggleProperty 'showMeta'
      return

    toggleReplyForm: ->
      @set('showforwardform', false)
      @set('showingadddeal', false)

      @toggleProperty 'showReplyForm'
      return

    toggleForwardForm: ->
      @set('showingadddeal', false)
      @set('showReplyForm', false)

      @toggleProperty 'showForwardForm'
      return

    makePublic: ->
      @set('model.isPersonal', false)
      @get('store').commit()

    archiveEmail: (item) ->
      @send 'removeSidebarItem', item, 'archive'

    deleteEmail: (item) ->
      @send 'removeSidebarItem', item, 'delete'

    removeSidebarItem: (item, action, threadAction) ->
      if @get('showReplyForm')
        @send 'closeForms'
        return

      if @get('showForwardForm')
        @send 'closeForms'

        return

      parentController = @get('parentController')

      @send action, item, action

    cancelCheckForResponse: (email) ->
      email.set 'checkForResponse', null

      email.one 'didUpdate', (result) =>
        @send 'flashSuccess', 'Response check cancelled'

      @get('store').commit()

    closeForms: ->
      @set('showReplyForm', false)
      @set('showForwardForm', false)
      @set('showingAddDeal', false)

    toggleAddDealForm: ->
      @set('showReplyForm', false)
      @set('showForwardForm', false)
      @toggleProperty 'showingAddDeal'

      false

    hideForm: ->
      @set 'showFormBox', false
      @set 'formBox.activeForm', null

  showMeta : false
  currentForm: 'todo'

  formBox: Ember.computed 'todoform', 'callform', ->
    Radium.FormBox.create
      todoForm: @get('todoForm')
      meetingForm: @get('meetingForm')
      # disable for now
      # callForm: @get('callForm')

  todoForm: Radium.computed.newForm('todo')

  email: Ember.computed 'model', ->
    model = @get('model')
    if model instanceof Radium.ObjectController
      model.get('model')
    else
      model

  todoFormDefaults: Ember.computed 'email', 'tomorrow', ->
    reference: @get('email')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    description: "Follow up with #{@get('model.subject')} email tomorrow."

  callForm: Radium.computed.newForm('call')

  meetingForm: Radium.computed.newForm('meeting')

  meetingFormDefaults: Ember.computed 'model', 'now', ->
    isExpanded: true
    topic: null
    users: Em.ArrayProxy.create(content: [])
    contacts: Em.ArrayProxy.create(content: [])
    startsAt: @get('now')
    endsAt: @get('now').advance(hour: 1)
    invitations: Ember.A()

  callFormDefaults: Ember.computed 'model', 'tomorrow', 'contact', ->
    reference: @get('email')
    finishBy: @get('tomorrow')
    user: @get('currentUser')
    contact: @get('contact')

  replyEmail: Ember.computed 'model', ->
    replyForm = Radium.ReplyForm.create
      currentUser: @get('currentUser')

    replyForm.set('repliedTo', @get('email'))

    replyForm

  forwardEmail: Ember.computed 'model', ->
    Radium.ForwardEmailForm.create
      email: @get('model')

  needs: ['messages', 'deals']
  hideUploader: true
  archiveEnabled: Radium.computed.notEqual 'controllers.messages.folder', 'archive'
