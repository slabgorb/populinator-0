class Simulation
  constructor: ->
    self = this
    $('.selectbox-wrapper').on 'click', =>
      self.sizeSettlement()

  # sets the value of one element to that of the other
  # copies e1 into e2
  copyVal: (giver, taker) ->
    $(taker).val($(giver).val())

  sizeSettlement: () ->
    $('#settlement-population-field').val $('#size').val()


$ ->
  simulation = new Simulation



