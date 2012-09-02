Fixtures.loadAll(now: true)

test 'when adding new item and there is a gap with items that are already in store, load them (forward)', ->
  Ember.run ->
    Radium.get('router').transitionTo('root.dashboard')

  section = F.feed_sections('default')
  todo = F.todos('default')

  waitForResource todo, (el) ->
    el.click()

    waitForSelector ['.add-todo', el], (el) ->
      el.click()

      waitForSelector '.radium-form', (el) ->
        section = F.feed_sections('month_from_now')

        Ember.run ->
          $('.more-options', el).click()

        fillIn '#finish-by-date', section.get('id')
        fillIn '#description', 'New todo'
        enterNewLine('#description')

        waitForResource section, (el) ->
          assertContains el, 'New todo'
          assertResource F.feed_sections('today')
          assertResource F.feed_sections('tomorrow')
          assertResource F.feed_sections('two_weeks_from_now')

test 'when adding new item and there is a gap with items that are already in store, load them (back)', ->
  section = F.feed_sections('month_from_now')
  item = section.get('items.firstObject')

  Ember.run ->
    Radium.get('router').transitionTo('root.dashboardWithDate', date: section.get('id'))

  waitForResource item, (el) ->
    el.click()

    waitForSelector ['.add-todo', el], (el) ->
      el.click()

      waitForSelector '.radium-form', (el) ->
        section = F.feed_sections('tomorrow')

        Ember.run ->
          $('.more-options', el).click()

        fillIn '#finish-by-date', section.get('id')
        fillIn '#description', 'New todo'
        enterNewLine('#description')

        waitForResource section, (el) ->
          assertContains el, 'New todo'
          assertResource F.feed_sections('two_weeks_from_now')
