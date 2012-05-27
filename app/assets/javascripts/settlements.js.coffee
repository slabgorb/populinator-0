# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ = jQuery
debug = false

class Settlement
  constructor: ->
    @name = $('#settlement_name')
    @pop  = $('#settlement_population')
    $('.randcheck.settlement-name').click =>
      $.get '/settlements/random-name',
        {}
        (data) => @name.val(data)
        'html'
    $('#submit-form').click ->
        parent('form').
        eq(0).
        trigger 'submit'
      false

    #make the selection box a pretty pretty princess
    $('select').selectbox()
    @pop.keyup => this.updateDrop
    @pop.keyup => this.forceInt
    $('#create-settlement').click -> this.createCallback
    $('.selectbox-wrapper').on 'click', =>
      this.sizeSettlement()

  sizeSettlement: () ->
    @pop.val $('#size').val()

  # change the dropbox to reflect the value in the pop field
  updateDrop: () =>
    pop = parseInt(@pop.val())
    $.each $('#size option'), ->
      if pop > parseInt($(this).val())
          $('#size_input').val($(this).text())

  # force the entry in the population to be an int
  forceInt: () =>
    parsed = parseInt(@pop.val())
    if (isNaN(parsed))
       @pop.val('')
    else
       @pop.val(parseInt(@pop.val()))



$(document).ready ->
  settlement = new Settlement();






