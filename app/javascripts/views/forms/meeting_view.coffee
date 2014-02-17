require 'lib/radium/time_picker_view'
require 'lib/radium/location_picker'
require 'lib/radium/meeting_autocomplete_view'
require 'views/forms/focus_textarea_mixin'

Radium.FormsMeetingView = Radium.FormView.extend
  actions:
    showCancelMeetingDialogue: ->
      return if @get('controller.isNew')

      dialogue =  @$('.cancel-meeting')

      dialogue.show()

      event.stopPropagation()

      $('html').on 'click.cancel-meeting', ->
        $('html').off 'click.cancel-meeting'
        dialogue.hide()

      false

  classNames: ['meeting-form-container']

  onFormReset: ->
    @$('form')[0].reset()

  readableStartsAt: ( ->
    @get('controller.startsAt').toHumanFormatWithTime()
  ).property('startsAt')

  willDestroyElement: ->
    $('html').off 'click.cancel-meeting'

  cancelMeetingDialogue: Radium.View.extend
    actions:
      cancel: ->
        @$().hide()

      cancelMeeting: ->
        @get('controller').send 'deleteMeeting'

        @$().hide()

    classNames: ['cancel-meeting']
    template: Ember.Handlebars.compile """
      <div class="cancel-meeting-content">
        <p>Are you sure you want to cancel meeting</p>
        <h3>{{controller.cancellationText}}</h3>
      </div>
      <div class="cancel-meeting-footer">
        <div class="pull-right">
          <button {{action "cancel" target="view" bubbles=false}} class="btn">No</button>
          <button {{action "cancelMeeting" target="view" bubbles=false}} class="btn btn-primary">YES, CANCEL</button>
        </div>
        <div>Notifications will be sent to attendees</div>
      </div>
    """

  topicField: Radium.MentionFieldView.extend Radium.TextFieldFocusMixin,
    Radium.FocusTextareaMixin,

    classNameBindings: ['isInvalid', ':meeting']
    disabledBinding: 'controller.isPrimaryInputDisabled'
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

    isSubmitted: Ember.computed.alias('controller.isSubmitted')

    click: (evt) ->
      evt.stopPropagation()

    keyDown: (evt) ->
      @set('controller.isExpanded', true) unless @get('controller.isExpanded')

    isInvalid: (->
      Ember.isEmpty(@get('value')) && @get('isSubmitted')
    ).property('value', 'isSubmitted')

  startsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.startsAt'
    isInvalid: ( ->
      return false unless @get('controller.isSubmitted')
      @get('controller.startsAtIsInvalid')
    ).property('controller.isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  endsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.endsAt'
    isInvalid: ( ->
      return false unless @get('isSubmitted')
      @get('controller.endsAtIsInvalid')
    ).property('isSubmitted', 'controller.startsAt', 'controller.endsAt', 'date')

  location: Radium.LocationPicker.extend
    valueBinding: 'controller.location'
    isInvalid: false

  attendees: Radium.MeetingAutocompleteView.extend()

  cancelMeetingDisabled: ( ->
    @get('controller.isDisabled') || @get('controller.isNew')
  ).property('controller.isDisabled', 'controller.isNew')
