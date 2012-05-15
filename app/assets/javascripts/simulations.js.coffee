class Simulation
  constructor: ->
    self = this
    $('.selectbox-wrapper').on 'click', =>
      self.sizeSettlement()
    $('a#run-simulation').click ->
      $('#pop-form fieldset').slideUp ->
        $('.loader').slideDown()
      $history = $('.report #history')
      $population = $('.report #population')
      $.post '/run',
        name: $('#settlement-name-field').val(),
        population: $('#settlement-population-field').val()
        dataType: 'json'
        (data) ->
          $('#settlement-id').text(data.settlement.name)
          $('.loader.tower').hide()
          $('ul.report').show()
          $.each data.settlement.residents, ->
            $population.append "
              <ul>
              <li class='name'>#{this.name}</li>
              <li class='gender'>#{this.gender}</li>
              <li class='age'>(#{this.age})</li>
              </ul>
              "
          $history.text(data.history)
      return false


  # sets the value of one element to that of the other
  # copies e1 into e2
  copyVal: (giver, taker) ->
    $(taker).val($(giver).val())

  sizeSettlement: () ->
    $('#settlement-population-field').val $('#size').val()

$ ->
  simulation = new Simulation



