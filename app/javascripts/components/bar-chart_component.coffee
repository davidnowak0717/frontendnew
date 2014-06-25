require 'mixins/components/chart_component_mixin'

Radium.BarChartComponent = Ember.Component.extend Radium.ChartComponentMixin,
  type: 'barChart'
  width: null
  height: 100
  classNames: 'bar-chart'
  domain: [0, 1]

  rotateText: ->
    @$(".x .tick text").each (index, element) ->
      if(!(parseInt($(element).text())))
        $(element).attr("transform", "rotate(20)")

  willDestroyElement: ->
    $(window).off('resize.chart')
    @get('parentView').removeChart(@get('chart'))

  refresh: ->
    @get('chart').refresh()

  resize: ->
    width = @$().parent().width()
    @get('chart').width(width).render()
    @rotateText()

  renderChart: ->
    chart = @get 'chart'
    domain = @get 'domain'
    valueAccessor = @get 'valueAccessor'
    width = @get('width')

    componentWidth = if width then width else @$().parent().width()

    chart
      .width(componentWidth)
      .height(@get('height'))
      .dimension(@get('dimension'))
      .group(@get('group'))
      .x(d3.time.scale().domain(domain))
      .round(d3.time.month.round)
      .brushOn(false)
      .mouseZoomable(false)
      .xUnits(d3.time.months)
      .valueAccessor((d) -> d.value[valueAccessor + '_total'])
      .renderLabel(@get('renderLabel'))
      .margins({top: 15, right: 10, bottom: 30, left: 60})

    chart.render()

    @rotateText()

    @get('parentView').registerChart(chart)

    # For debugging
    @$().data('chart', chart)

    $(window).on('resize.chart', _.debounce(@resize.bind(this), 50).bind(this))
