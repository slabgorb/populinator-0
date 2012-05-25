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
     $('.randcheck.being-name').click ->
      $.get '/being/random-name',
        (data) ->
          $('#person_name').val data[1]
          $('#person_gender').val data[0]
          $('#person_age').val data[2]
        'json'

$ ->
  window.being = new Being()
  window.beingGraph = new BeingGraph(200, 200, 10)
  window.beingGraph.graphData()
