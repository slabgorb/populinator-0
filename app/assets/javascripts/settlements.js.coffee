# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ = jQuery

debug = false

$ ->
  #
  # set up the colorpicker
  #

  $('#settlement-color').colorpicker().blur ->
    $('#icon-preview').css('background-color', $(this).val())


  #
  # icon typeahead
  #
  $('#settlement-icon').typeahead
    source: $.getJSON '/icon-list'
    items: 5

  #
  # random icon
  #
  $('#random-icon').click (e) =>
    $.getJSON '/icon-list', (data) ->
      $('#settlement-icon').val(data[Math.floor(Math.random()*data.length)])
      preview()

  #
  # preview for the icon
  #
  preview = ->
    $('#icon-preview').css('background-image', "url('/assets/heraldry/" + $('#settlement-icon').val() + ".png')")

  $('#settlement-icon').change preview

  #
  # random settlement name
  #
  $('#random-name').click =>
    $.get '/random/name/settlement',
        {}
        (data) => $('#settlement-name').val(data)
        'html'

  #
  # force the entry in the population box to be an integer
  #
  forceInt = ->
    pop = $('#settlement-population')
    parsed = parseInt(pop.val())
    if (isNaN(parsed))
       pop.val('')
    else
       pop.val(parsed)

  $('#settlement-population').keyup forceInt
