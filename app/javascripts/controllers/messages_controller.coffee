Radium.MessagesController = Radium.ArrayController.extend Radium.CheckableMixin, Radium.SelectableMixin,
  needs: ['application', 'emailsShow', 'messagesDiscussion']
  applicationController: Ember.computed.alias 'controllers.application'

  folderBinding: 'model.folder'

  folders: [
    { title: 'Inbox', name: 'inbox', icon: 'mail' }
    { title: 'Sent items', name: 'sent', icon: 'send' }
    { title: 'Discussions', name: 'discussions', icon: 'chat' }
    { title: 'All Emails', name: 'emails', icon: 'mail' }
    { title: 'Attachments', name: 'attachments', icon: 'attach' }
    { title: 'Meeting invites', name: 'invites', icon: 'calendar' }
  ]

  selectionsDidChange: (->
    if @get('content').filterProperty('isChecked').get('length')
      @transitionToRoute 'messages.bulk_actions'
    else if @get('applicationController.currentPath') == 'messages.bulk_actions'
      if email = @get('controllers.emailsShow.model')
        @send 'selectItem', email
      else if discussion = @get('controllers.messagesDiscussion')
        @send 'selectItem', discussion
  ).observes('content.@each.isChecked')

  canSelectItems: (->
    @get('checkedContent.length') == 0
  ).property('checkedContent.length')

  noSelection: (->
    return false if @get('selectedContent')
    return false if @get('hasCheckedContent')
    true
  ).property('hasCheckedContent', 'selectedContent')

  clear: ->
    @get('content').clear()

  load: ->
    @get('content').load()

  selectedSearchScope: "Search All Emails"
