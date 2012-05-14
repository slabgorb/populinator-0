# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ = jQuery
debug = false

Settlement = () ->
  @name = $('#settlement-name-field')
  @pop  = $('#settlement-population-field')
  $('.randcheck.name').click =>
    $.getJSON '/settlements/random-name', (name) =>
      @name.val(name[0])
      @pop.val(name[1])

  #make the selection box a pretty pretty princess
  $('select').selectbox()

  updateDrop = () =>
    pop = parseInt(@pop.val())
    $.each $('#size option'), ->
      if pop > parseInt($(this).val())
          $('#size_input').val($(this).text())

  @pop.keyup updateDrop

  # force the entry in the population to be an int
  $('#settlement_population').keyup ->
    parsed = parseInt($(this).val())
    if (isNaN(parsed))
      $(this).val('')
    else
      $(this).val(parseInt($(this).val()))

  # bind the 'create' link to a post ajax call with a callback
  $('#create-settlement').click ->
    options =
      'settlement[name]': $('#settlement_name').val(),
      'settlement[population]': $('#settlement_population').val()
    $.post '/settlements', options,   (data, textStatus) ->
        $('#info-settlement dd.name').html( '<a href="/settlement/' + data.id + '">' + data.name + '</a>')
        $('#info-settlement dd.population').text(data.population)
      ,"json"
    false




$(document).ready ->
  settlement = new Settlement();






