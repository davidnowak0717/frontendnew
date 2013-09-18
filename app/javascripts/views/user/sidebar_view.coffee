require 'lib/radium/combobox'
require 'lib/radium/text_combobox'
require 'lib/radium/phone_input'
requireAll /views\/sidebar/

Radium.UserSidebarView = Radium.FixedSidebarView.extend
  didInsertElement: ->
    @_super()
    Ember.run.scheduleOnce 'afterRender', this, ->
      @get('controller').addObserver('isEditing', =>
        @setSidebarHeight()
      )
