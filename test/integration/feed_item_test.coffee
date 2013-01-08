module 'Integration - Feed'

integrationTest 'feed type gets clustered after reaching the cluster size', ->
  expect(3)
  assertEmptyFeed()

  section = Factory.create 'feed_section'

  app ->
    for i in [0..8]
      todo = Factory.create 'todo'
      Radium.get('router.activeFeedController').pushItem todo

  waitForResource section, (el) ->
    assertFeedItems 0
    assertText el, '9 todos'

integrationTest 'a feed can be filtered by feed type', ->
  expect(7)

  assertEmptyFeed()

  section = Factory.create 'feed_section'

  app ->
    for i in [0..2]
      section.get('items').pushObject Factory.create 'todo'

    for i in [0..1]
      section.get('items').pushObject Factory.create 'deal'

    section.get('items').pushObject Factory.create 'campaign'
    section.get('items').pushObject Factory.create 'meeting'

    Radium.get('router.activeFeedController.content').pushObject section

  waitForResource section, (el) ->
    assertFeedItems(7)

    clickFilterAndAssertFeedItems 'todo', 3
    clickFilterAndAssertFeedItems 'deal', 2
    clickFilterAndAssertFeedItems 'campaign', 1
    clickFilterAndAssertFeedItems 'meeting', 1
    clickFilterAndAssertFeedItems 'all', 7

integrationTest 'a feed can retrieve new items from infinite scrolling in both directions', ->
  expect(4)

  assertEmptyFeed()

  loadFeedFixtures([8, 14])

  controller = Radium.get('router.activeFeedController')

  app ->
    controller.pushItem Factory.create 'todo'

  feedSelector = ".feed_section_#{Ember.DateTime.create().toDateFormat()}"

  waitForSelector feedSelector, (el) ->
    assertFeedItems 1

    assertScrollingFeedHasDate(controller, 14, forward: true)
    assertScrollingFeedHasDate(controller, -14, back: true)

integrationTest 'a feed can jump to a specific date', ->
  expect(2)

  assertEmptyFeed()

  loadFeedFixtures([8, 14, 27])

  controller = Radium.get('router.activeFeedController')
  router = Radium.get('router')

  app ->
    controller.pushItem Factory.create 'todo'

  feedSelector = ".feed_section_#{Ember.DateTime.create().toDateFormat()}"

  waitForSelector feedSelector, (el) ->
    futureDate = Ember.DateTime.create().advance(day: 27)

    app ->
      router.send 'scrollFeedToDate', date: futureDate.toDateFormat()

    waitForSelector ".feed_section_#{futureDate.toDateFormat()}", (el) ->
      assertText el, futureDate.toFormattedString('%A, %B %D, %Y')
