Radium.FormsTodoView = Ember.View.extend
  checkbox: Ember.View.extend
    disabled: (->
      @get('controller.isDisabled') || @get('controller.isNew')
    ).property('controller.isDisabled', 'controller.isNew')

    click: (event) ->
      event.stopPropagation()

    init: ->
      @_super.apply this, arguments
      @on "change", this, this._updateElementValue

    _updateElementValue: ->
      @set 'checked', this.$('input').prop('checked')

    checkedBinding: 'controller.isFinished'
    classNames: ['checker']
    tabindex: 4
    checkBoxId: (->
      "checker-#{@get('elementId')}"
    ).property()

    template: Ember.Handlebars.compile """
      <input type="checkbox" id="{{unbound view.checkBoxId}}" {{bindAttr disabled=view.disabled}}/>
      <label for="{{unbound view.checkBoxId}}"></label>
    """

  todoField: Radium.MentionFieldView.extend
    classNameBindings: ['value:is-valid', 'isInvalid', ':todo']
    valueBinding: 'controller.description'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

    isCall: Ember.computed.alias('controller.isCall')
    referenceName: Ember.computed.alias('controller.reference.name')
    date: Ember.computed.alias('controller.finishBy')

    disabled: (->
      if @get('controller.isDisabled')
        true
      else if(!@get('controller.isNew') && !@get('controller.isExpanded'))
        true
      else
        false
    ).property('controller.isNew', 'controller.isExpanded')

    placeholder: (->
      if @get('isCall') && @get('referenceName')
        "Add a call to #{@get('referenceName')} for #{@get('date').toHumanFormat()}"
      else if @get('isCall')
        "Add a call for #{@get('date').toHumanFormat()}"
      else if !@get('isCall') && @get('referenceName')
        "Add a todo about #{@get('referenceName')} for #{@get('date').toHumanFormat()}"
      else
        "Add a todo for #{@get('date').toHumanFormat()}"
    ).property('reference.name')

  datePicker: Ember.View.extend
    classNameBindings: [
      'date:is-valid'
      'disabled:is-disabled'
      'isInvalid'
      ':control-box'
      ':datepicker-control-box'
    ]

    dateBinding: 'controller.finishBy'
    textBinding: 'textToDateTransform'
    disabled: Ember.computed.alias('controller.isDisabled')

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

    textToDateTransform: ((key, value) ->
      if arguments.length == 2
        if value && /\d{4}-\d{2}-\d{2}/.test(value)
          @set 'date', Ember.DateTime.parse(value, '%Y-%m-%d')
        else
          @set 'date', null
      else if !value && @get('date')
        @get('date').toHumanFormat()
      else
        value
    ).property()

    defaultDate: (->
      Ember.DateTime.create().toDateFormat()
    ).property()

    didInsertElement: ->
      return if @$('.datepicker-link').length is 0

      @$('.datepicker-link').datepicker()

      view = this

      @$('.datepicker-link').data('datepicker').place = ->
        mainButton = view.$('.btn.dropdown-toggle')

        offset = mainButton.offset()

        @picker.css
          top: offset.top + @height,
          left: offset.left

      @$('.datepicker-link').data('datepicker').set = ->
        view.set 'text', Ember.DateTime.create(@date.getTime()).toDateFormat()
        @hide()

    template: Ember.Handlebars.compile """
      {{#if view.disabled}}
        <i class="icon-calendar"></i>
      {{else}}
        <div class="btn-group">
          <button class="btn dropdown-toggle" data-toggle="dropdown">
            <i class="icon-calendar"></i>
          </button>
          <ul class="dropdown-menu">
            <li><a {{action setDate 'today' target=view}}>Today</a></li>
            <li><a {{action setDate 'tomorrow' target=view}}>Tomorrow</a></li>
            <li><a {{action setDate 'this_week' target=view}}>Later This Week</a></li>
            <li><a {{action setDate 'next_week' target=view}}>Next Week</a></li>
            <li><a {{action setDate 'next_month' target=view}}>In a Month</a></li>
            <li>
              <a class="datepicker-link" data-date="{{unbound view.defaultDate}}" href="#">
                <i class="icon-calendar"></i>Pick a Date
              </a>
            </li>
          </ul>
        </div>
      {{/if}}
      <span class="text">Due</span>
      {{view view.humanTextField}}
    """

    setDate: (key) ->
      date = switch key
        when 'today'
          Ember.DateTime.create().atEndOfDay()
        when 'tomorrow'
          Ember.DateTime.create().advance(day: 1)
        when 'this_week'
          Ember.DateTime.create().atEndOfWeek()
        when 'next_week'
          Ember.DateTime.create().advance(day: 7)
        when 'next_month'
          Ember.DateTime.create().advance(month: 1)

      @set 'text', date.toHumanFormat()

    humanTextField: Ember.TextField.extend
      valueBinding: 'parentView.text'
      disabledBinding: 'parentView.disabled'


  userPicker: Ember.View.extend
    classNameBindings: [
      'user:is-valid', 
      'isInvalid',
      ':control-box',
      ':datepicker-control-box'
    ]

    disabled: Ember.computed.alias('controller.isDisabled')
    userBinding: 'controller.user'
    nameBinding: 'nameToUserTransform'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')
    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

    nameToUserTransform: ((key, value) ->
      if arguments.length == 2
        result = Radium.User.all().find (user) =>
          user.get('name') is value
        @set 'user', result
      else if !value && @get('user')
        @get 'user.name'
      else
        value
    ).property()

    template: Ember.Handlebars.compile """
      <span class="text">
        Assigned To
      </span>

      {{view view.textField}}
      <div class="btn-group">
        <button class="btn dropdown-toggle" data-toggle="dropdown">
          <i class="icon-chevron-down"></i>
        </button>
        <ul class="dropdown-menu">
          {{#each users}}
            <li><a {{action setName this.name target=view href=true}}>{{name}}</a></li>
          {{/each}}
        </ul>
      </div>
    """

    setName: (name) ->
      @set 'name', name

    textField: Ember.TextField.extend
      valueBinding: 'parentView.name'
      disabledBinding: 'parentView.disabled'

      didInsertElement: ->
        @$().typeahead source: @source

      # FIXME: make this async
      source: (query, process) ->
        Radium.User.all().map((c) -> c.get('name')).toArray()

  submit: ->
    return unless @get('controller.isValid')
    @get('controller').submit()
    @get('controller').reset()
