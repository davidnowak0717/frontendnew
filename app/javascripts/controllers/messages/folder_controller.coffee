Radium.MessagesFolderController = Ember.ObjectController.extend
  needs: ['messages']
  isSelected: (->
    @get('controllers.messages.folder') == @get('name')
  ).property('controllers.messages.folder')