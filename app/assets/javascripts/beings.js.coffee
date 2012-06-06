debug = false

class BeingGraph
    constructor: (width, height, padding) ->
      @d3 = d3.select("#being-graph").
        append("div")
    graphData: =>
      $.get '/beings',
        (data) =>
          console.log data if debug
          if data.length > 0
            @d3.selectAll('div').
              data(data).
              enter().append('div').
              style('width', (d) ->
                d * 10 + 'px'
              ).
              text((d) -> d.age)
        'json'


class Being
   constructor: ->
     $.each $('li.being'), ->
      $b = $(this)
      options =
        style:
          classes: 'ui-tooltip-plain'
          width: '220px'
        content:
          text: 'Loading...'
          ajax:
            url: '/beings/genotype/' + $b.find('input').val()
            type: 'GET'
        hide:
          fixed: true
        position:
          my: 'top center'
          at: 'bottom center'
      $b.qtip options





$ ->
  window.being = new Being()
  window.beingGraph = new BeingGraph(200, 200, 10)
  #window.beingGraph.graphData()
  $('table').tablesorter
    headers:
      5:
        sorter: false
      6:
        sorter: false
      7:
        sorter: false
      8:
        sorter: false
