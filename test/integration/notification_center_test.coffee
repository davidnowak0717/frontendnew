module 'Integration - Notification Center'

integrationTest 'lead notifications', ->
  contact = Factory.create 'contact'

  notification = Factory.create 'notification'
    reference:
      id: -> contact
      type: 'contact'
    tag: 'new.lead'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, contact.get('name')

    clickNotification notification

    assertOnPage contactPath(contact)

integrationTest 'campaign assignments appear', ->
  campaign = Factory.create 'campaign'

  notification = Factory.create 'notification'
    reference:
      id: -> campaign
      type: 'campaign'
    tag: 'assigned.campaign'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, campaign.get('name')

    clickNotification notification

    assertOnPage campaignPath(campaign)

integrationTest 'contact assignment notifications', ->
  contact = Factory.create 'contact'

  notification = Factory.create 'notification'
    reference:
      id: -> contact
      type: 'contact'
    tag: 'assigned.contact'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, contact.get('name')

    clickNotification notification

    assertOnPage contactPath(contact)

integrationTest 'deal assignment notifications', ->
  deal = Factory.create 'deal'

  notification = Factory.create 'notification'
    reference:
      id: -> deal
      type: 'deal'
    tag: 'assigned.deal'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem deal

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, deal.get('name')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'group assignment notifications', ->
  group = Factory.create 'group'

  notification = Factory.create 'notification'
    reference:
      id: -> group
      type: 'group'
    tag: 'assigned.group'

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, group.get('name')

    clickNotification notification

    assertOnPage groupPath(group)

integrationTest 'todo assignments appear', ->
  todo = Factory.create 'todo'
    description: 'schedule group meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> todo
      type: 'todo'
    tag: 'assigned.todo'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem todo

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest  'meeting invitation notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'invited.meeting'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem meeting

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'cancelled meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'cancelled.meeting'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem meeting

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'confirmed meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'confirmed.meeting'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem meeting

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'rejected meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'rejected.meeting'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem meeting

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'rescheduled meeting notifications', ->
  meeting = Factory.create 'meeting'

  notification = Factory.create 'notification'
    reference:
      id: -> meeting
      type: 'meeting'
    tag: 'rescheduled.meeting'

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem meeting

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, meeting.get('topic')

    clickNotification notification

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'

integrationTest 'reminder notifications', ->
  todo = Factory.create 'todo'

  reminder = Factory.create 'reminder'
    reference:
      id: -> todo
      type: 'todo'
    time: -> Ember.DateTime.create().toFullFormat()

  # FIXME: having to manually push onto the feed controller
  # after items are created seems like an anti pattern
  app ->
    Radium.get('router.activeFeedController').pushItem todo

  assertNotifications 1

  openNotifications (notificationCenter) ->
    assertText notificationCenter, todo.get('description')

    clickReminder reminder

    waitForSelector '.feed-info', ->
      ok true, 'Feed item expanded'
