# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ = jQuery
debug = false

$(document).ready ->
  # random name
  $('#random-settlement-name').click ->
    $sn = $('#settlement_name')
    $sp = $('#settlement_population')
    if $(this).is(':checked')
      console.log('checked state') if debug
      $sn.stash()
      $sp.stash()
      $.getJSON '/settlements/random-name', (name)->
        $sn.val(name[0])
        $sp.val(name[1])
    else
      console.log('unchecked state') if debug
      $sn.unstash()
      $sp.unstash()
    true

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
