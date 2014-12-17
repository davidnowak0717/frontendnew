Radium.PeopleIndexView = Radium.View.extend
  setup: Ember.on 'didInsertElement', ->
    @resizeTableContainer()
    $(window).on 'resize.table-container-resize', @resizeTableContainer.bind(this)
    $(document).on 'click.clear-menu', @clearMenus.bind(this)
    @$('.col-selector .dropdown-toggle').on 'click.col-selector', @showHideColumnSelector

  showHideColumnSelector: (e) ->
    target = $(e.target)

    parent = target.parents('.col-selector')

    parent.toggleClass('open')

  clearMenus: (e) ->
    target = $(e.target)
    menu = $('.col-selector')

    if e.target == menu || target.parents('.col-selector').length
      return @resizeTableHeaders()

    menu.removeClass('open') if menu.hasClass('open')

  resizeTableHeaders: ->
    rightHeight = $('.contacts-table:last thead tr th:first').outerHeight() - 1

    Ember.run.next ->
      $('.contacts-table:first thead tr th').each (index, th) ->
        $(th).height(rightHeight)


  resizeTableContainer: ->
    tableContainer = @$('.table-container')

    buffer = 100

    left = tableContainer.offset().left
    availableWidth = document.body.clientWidth - left - buffer

    tableContainer.width(availableWidth)

  teardown: Ember.on 'willDestroyElement', ->
    @$('ul.col-menu').off 'click.col-menu'
    $(window).off 'resize.table-container-resize'
    @$('.col-selector .dropdown-toggle').off 'click-col-selector'
    $(document).off 'click.clear-menu'