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
    this.initSlider()
    this.initButtons()

  addHistoricalEvent: (historical_event) =>

    "<dt>
       <span class='smaller'>age #{historical_event['age']}</span> :: #{historical_event['name']}
     </dt>
     <dd>
        #{historical_event['description']}
     </dd>
    "


  updateHistory: (history) =>
    $('dl.events').html =>
      events = (this.addHistoricalEvent event for event in history)
      events.join('')

  initButtons: =>
    self = this
    callback = ($button, act) =>
      $beingTitle = $('#being-title, #being-title li')
      $.ajax ('/beings/' + act + '/' + $('#being-id').val()),
        type: 'put'
        success: (data, textStatus, jqXHR) ->
          $button.unbind 'click'
          self.updateHistory data['history']
          other_act = if act == 'kill' then 'Resurrect' else 'Kill'
          $button.text("#{other_act} #{$('#being-name').val()}")
          $button.attr('id', '#{other_act.toLowerCase()}-button')
          $button.click (event) ->
            callback $button, other_act.toLowerCase()
            false
          if act == 'kill' then $beingTitle.addClass 'dead' else $beingTitle.removeClass 'dead'

    $('#kill-button').bind 'click', (event) ->
      callback $(this), 'kill'
      false
    $('#resurrect-button').bind 'click', (event) ->
      callback $(this), 'resurrect'
      false

  initSlider: =>
    self = this
    # set up the slider
    $('.slider').slider
      # start with the current age
      range: 'min'
      value: $('#being-age').val()
      # allow making them into an infant
      min: 0
      # max is the old age for this being plus a small multiplier
      max: $('#being-old-age').val() * 1.20
      slide: (event, ui) =>
        $('#age-change').val(ui.value - $('#being-age').val() )
        $('.being-age').eq(0).text ui.value
      stop: (event, ui) ->
        $.ajax '/beings/age/' + $('#being-id').val(),
          data:
            years: $('#age-change').val()
          type: 'put'
          success: (data, textStatus, jqXHR) =>
            $('#being-age').val data['age']
            self.updateHistory data['history']

    if $('#being-alive').val() == 'true'
      $('.slider-wrapper').effect 'slide', {}, 500




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
