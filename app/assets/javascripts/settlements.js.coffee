# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ = jQuery

$(document).ready ->
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

  $('#settlement_population').keyup ->
    parsed = parseInt($(this).val())
    if (isNaN(parsed))
      $(this).val('')
    else
      $(this).val(parseInt($(this).val()))
