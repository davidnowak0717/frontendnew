require 'lib/radium/progress_bar'
require 'lib/radium/value_validation_mixin'

Radium.DealsNewView = Ember.View.extend Radium.ScrollTopMixin, Radium.ScrollTopMixin,
  actions:
    toggleChecklist: (evt) ->
      return if @get('disabled')

      @$('.checklist-items-container').slideToggle('medium')
      @toggleProperty 'showChecklistItems'

    toggleDetail: (evt) ->
      @$('#deal-detail').slideToggle('medium')
      @toggleProperty 'showDetail'

  classNames: ['page-view']
  layoutName: 'layouts/single_column'
  showChecklistItems: false
  showDetail: false
  disabled: false

  name: Ember.TextField.extend Radium.ValueValidationMixin,
    valueBinding: 'targetObject.name'
    disabledBinding: 'parentView.disabled'
    didInsertElement: ->
      @$().focus()

  description: Radium.TextArea.extend Radium.ValueValidationMixin,
    disabledBinding: 'parentView.disabled'
    rows: 3
    valueBinding: 'targetObject.description'

  dealStates: Ember.View.extend
    template: Ember.Handlebars.compile """
      <ul>
      {{#each status in controller.statuses}}
        <li>
        {{x-radio name="type" selection=controller.status leader=status value=status}}
        </li>
      {{/each}}
      </ul>
    """

  dealValue: Ember.View.extend
    classNameBindings: ['isValid','isInvalid', 'valueInvalid', ':deal-value', ':field', ':control-box']

    template: Ember.Handlebars.compile """
      <span  class="text dollar">{{currencySymbol}}</span>
      {{currency-input value=value submit='submit' class="field input-medium negotitating"}}
      {{#if view.valueInvalid}}
        <span class="error"><i class="ss-standard ss-alert"></i>Value must be greater than 0.</span>
      {{/if}}
    """

    focusIn: (e) ->
      @_super.apply this, arguments

      value = e.target?.value
      return unless value?.length

      if /\d+/.exec(value)[0] == "0"
        e.target.value = ''

    valueInvalid: Ember.computed 'controller.value', 'controller.isSubmitted', ->
      return false unless @get('controller.isSubmitted')
      value = @get('controller.value')

      return true if Ember.isEmpty value

      parseInt(value) == 0

    isValid: Ember.computed 'controller.value', 'controller.isSubmitted', ->
      value = @get('controller.value')

      return false if Ember.isEmpty value

      value.toString().isCurrency()

    isInvalid: Ember.computed 'controller.value', 'controller.isSubmitted', ->
      (not @get('isValid')) && @get('controller.isSubmitted')

  referenceName: Ember.computed 'controller.reference', ->
    # FIXME : can we use toString on the models?
    reference = @get('controller.reference')

    return unless reference

    return reference.get('subject') if reference.constructor is Radium.Email
    return reference.get('topic') if reference.constructor is Radium.Todo
    return reference.get('displayName') if reference.constructor is Radium.Contact

    ""
