class Simulation
  constructor: ->
    @animationDuration = 500
    self = this
    @history = $('.report #history')
    @population = $('.report #population')
    @ruler = $('.report #ruler')
    $('.selectbox-wrapper').on 'click', =>
      self.sizeSettlement()

    # set up the reset button
    $('a#simulation-reset').on 'click', =>
      if $('#pop-form').length > 0
        $('ul.report').fadeOut @animationDuration, ->
          $('#pop-form fieldset').fadeIn @animationDuration
        false
      else
        true

    $('a#run-simulation').click =>
      $('#pop-form fieldset').fadeOut @animationDuration, ->
        $('.loader').fadeIn(@animationDuration)
      $.post '/run',
        name: $('#settlement-name-field').val(),
        population: $('#settlement-population-field').val()
        dataType: 'json'
        (settlement) => self.loadSettlement(settlement)
      return false

  loadSettlement: (settlement) ->
    $('#settlement-id').text(settlement.name)
    $('.loader.tower').fadeOut @animationDuration, =>
      $('ul.report').fadeIn @animationDuration
    $.each settlement.families, (surname, members) =>
      markup = "
        <div class='clear'></div>
        <h3>#{surname}</h3>
        <ul class='family'>
      "
      $.each members, (index, member) =>
        markup += this.residentTemplate(member)
      markup += "</ul>"
      @population.append(markup)
    @history.html(settlement.history)
    @ruler.append this.residentTemplate(settlement.ruler)

  residentTemplate: (resident) ->
    age =  if resident.alive? then ('aged ' + resident.age) else 'dead'
    """
      <ul>
        <li class='name'>#{resident.name}</li>

        <li class='gender #{resident.gender}'>&nbsp;</li>
        <li class='age'>(#{age})</li>
      </ul>

    """


  # sets the value of one element to that of the other
  # copies e1 into e2
  copyVal: (giver, taker) ->
    $(taker).val($(giver).val())

  sizeSettlement: () ->
    $('#settlement-population-field').val $('#size').val()

$ ->
  simulation = new Simulation



