
$ = jQuery

$(document).ready ->
  $('#random-ruler-name').click ->
    $rg = $('#ruler_gender')
    $rgn = $('#ruler_given_name')
    $rsn = $('#ruler_surname')
    $ra = $('#ruler_age')
    if $(this).is(':checked')
      console.log('checked state') if debug
      $rg.stash()
      $rgn.stash()
      $rsn.stash()
      $ra.stash()
      $.getJSON '/people/random-name', (name)->
        $rg.val(name[0])
        $rgn.val(name[1][0])
        $rsn.val(name[1][1])
        $ra.val(name[2])
    else
      console.log('unchecked state') if debug
      $rg.unstash()
      $rgn.unstash()
      $rsn.unstash()
      $ra.unstash()
    true
