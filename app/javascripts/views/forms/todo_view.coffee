require 'views/forms/todo_field_view'
require 'views/forms/form_view'
require 'views/forms/focus_textarea_mixin'

Radium.FormsTodoView = Radium.FormView.extend Radium.ContentIdentificationMixin,
  didInsertElement: ->
    @_super.apply this, arguments
    return unless @get('controller').on
    @set 'store', @get('controller.store')
    @set 'model', @get("controller.model")

    return unless @get('controller.overdue')

    Ember.run.scheduleOnce 'afterRender', this, '_afterRender'

  _afterRender: ->
    return unless @get('controller.overdue')

    @$('.overdue-alert')?.tooltip(html: true)

  _teardown: Ember.on 'willDestroyElement', ->
    @_super.apply this, arguments

    @controller.EventBus.unsubscribe "todo:formSubmitted"
    if alert = @$('.overdue-alert')
      alert.tooltip('destroy')

  finishView: Radium.View.extend Ember.ViewTargetActionSupport,
    tagName: 'button'
    classNameBindings: ["isFinished", ":btn", ":btn-link", ":pull-left", ":events-list-item-button", ":finish-todo"]
    attributeBindings: 'title'

    setup: Ember.on 'didInsertElement', ->
      @_super.apply this, arguments

      unless @get('controller.isNew')
        @$().tooltip()

    teardown: Ember.on 'willDestroyElement', ->
      @_super.apply this, arguments

      if @$().data('tooltip')
        @$().tooltip('destroy')

    click: ->
      @triggerAction
        action: 'finishTask'

      false

    template: Ember.Handlebars.compile """
      <i class="ss-standard ss-check"></i>
    """

    title: Ember.computed 'controller.isDisabled', 'controller.isFinished', ->
      if @get('controller.isFinished')
        "Mark as not done"
      else
        "Mark as done"

  todoField: Radium.FormsTodoFieldView.extend Radium.TextFieldFocusMixin,
    Radium.FocusTextareaMixin,

    attributeBindings: ['readonly']
    value: 'controller.description'
    readonlyBinding: 'controller.isPrimaryInputDisabled'
    finishBy: Ember.computed.alias 'controller.finishBy'
    placeholder: Ember.computed 'reference.name', 'controller.finishBy', ->
      pre = if @get('referenceName') and !@get('controller.reference.token')
              "Add a todo about #{@get('referenceName')}"
            else
              "Add a todo"

      return pre unless @get('finishBy')

      "#{pre} for #{@get('finishBy').toHumanFormat()}"

  onFormReset: ->
