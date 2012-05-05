
$(document).ready ->
  $('#tabs').tabs();
  $('#settlement_population').keyup ->
    parsed = parseInt($(this).val())
    if (isNaN(parsed))
      $(this).val('')
    else
      $(this).val(parseInt($(this).val()))

  $( "input:submit, .button").button()

