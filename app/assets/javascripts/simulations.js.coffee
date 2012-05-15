class Simulation
  constructor: ->
    fade_time = 500
    self = this
    $('.selectbox-wrapper').on 'click', =>
      self.sizeSettlement()
    $('a#run-simulation').click ->
      $('#pop-form fieldset').fadeOut fade_time, ->
        $('.loader').fadeIn(fade_time)
      $history = $('.report #history')
      $population = $('.report #population')
      $ruler = $('.report #ruler')
      $.post '/run',
        name: $('#settlement-name-field').val(),
        population: $('#settlement-population-field').val()
        dataType: 'json'
        (data) ->
          settlement = data.settlement
          $('#settlement-id').text(settlement.name)
          $('.loader.tower').fadeOut fade_time, ->
            $('ul.report').fadeIn fade_time
          $.each settlement.residents, ->
            age =  if this.alive? then ('aged ' + this.age) else 'dead'
            $population.append """
              <ul >
              <li class='name'>#{this.name}</li>
              <li class='gender #{this.gender}'>&nbsp;</li>
              <li class='age'>(#{age})</li>
              </ul>
              """
          $history.html(data.history)
          console.log settlement
          $ruler.append "
            <ul>
            <li class='name'>#{settlement.ruler.name}</li>
            <li class='gender #{settlement.ruler.gender}'>&nbsp;</li>
            <li class='age'>(#{settlement.ruler.age})</li>
            </ul>
            "
      return false


  # sets the value of one element to that of the other
  # copies e1 into e2
  copyVal: (giver, taker) ->
    $(taker).val($(giver).val())

  sizeSettlement: () ->
    $('#settlement-population-field').val $('#size').val()

$ ->
  simulation = new Simulation



