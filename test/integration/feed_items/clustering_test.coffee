test 'clustering feed items', ->

  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections('default')

  waitForResource section, (el) ->
    assertNotContains el, 'Finish first product draft'
    assertContains el, '6 todos'

    cluster = $('.cluster-item', el)
    cluster.click()

    todo = F.todos('default')

    waitForResource todo, (el) ->
      assertContains el, 'Finish first product draft'
