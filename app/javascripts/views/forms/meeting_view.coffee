require 'views/forms/time_picker_view'
Radium.FormsMeetingView = Ember.View.extend
  checkbox: Radium.FormsCheckboxView.extend()

  topicField: Radium.MentionFieldView.extend
    placeholder: 'Add meeting topic'
    valueBinding: 'controller.topic'

  topicField: Radium.MentionFieldView.extend
    classNameBindings: [':meeting']
    placeholder: 'Add meeting topic'

  datePicker: Radium.FormsDatePickerView.extend
    classNames: ['input-small']
    dateBinding: 'controller.startsAt'
    leader: 'When:'

  startsAt: Radium.TimePickerView.extend
    leader: 'Starts:'

  endsAt: Radium.TimePickerView.extend
    dateBinding: 'controller.endsAt'
    leader: 'ends:'

