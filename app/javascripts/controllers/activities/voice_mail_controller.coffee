Radium.ActivitiesVoiceMailController = Radium.ObjectController.extend
  voiceMail: Ember.computed.alias 'reference'
  to: Ember.computed.alias 'voiceMail.to'
  from: Ember.computed.alias 'voiceMail.from'

  icon: 'phone'
