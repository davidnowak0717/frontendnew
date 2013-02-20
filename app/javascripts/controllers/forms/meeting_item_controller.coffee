Radium.MeetingItemController = Em.ObjectController.extend
  hasConflict: ( ->
    false
  ).property('startsAt', 'endsAt')

  timeSpan: ( ->
    "#{@get('startsAt').toMeridianTime()} to #{@get('startsAt').toMeridianTime()}"
  ).property('startsAt', 'endsAt')

  topic: ( ->
    @get('content.topic')
  ).property('topic')
