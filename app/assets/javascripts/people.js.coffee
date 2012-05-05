
$(document).ready ->

  $('#random-ruler-name').click ->
    $.getJSON '/people/random-name', (name)->
      $('#ruler_gender').val(name[0])
      $('#ruler_given_name').val(name[1][0])
      $('#ruler_surname').val(name[1][1])
      $('#ruler_age').val(name[2])
    false
