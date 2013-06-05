Radium.SidebarBaseController = Radium.ObjectController.extend
  isEditable: true
  isEditing: false

  stopEditing: ->
    return if @get('isSaving')
    return unless @get('isValid')
    @commit()

  startEditing: ->
    return if @get('isSaving')
    @get('form').reset()
    @setForm()

  commit: ->
    model = @get('model')
    model.setProperties(@get('form').getProperties(@get('form.properties')))

    return unless model.get('isDirty')

    model.one 'becameInvalid', (result) ->
      console.log model.get('errors.length')

    model.one 'bacameError', ->
      console.log model.get('errors.length')

    model.one 'didUpdate', (result) ->
      console.log 'didUpdate'

    @get('store').commit()
