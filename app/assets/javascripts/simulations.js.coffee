
$(document).ready ->
  $('#tabs').tabs();
  $('#settlement_population').keyup ->
    parsed = parseInt($(this).val())
    if (isNaN(parsed))
      $(this).val('')
    else
      $(this).val(parseInt($(this).val()))

  $( "input:submit").button()

  $('#random-name').click ->
    $.getJSON '/random-name', (name)->
      $('#ruler_gender').val(name[0])
      $('#ruler_given_name').val(name[1][0])
      $('#ruler_surname').val(name[1][1])
      $('#ruler_age').val(name[2])

