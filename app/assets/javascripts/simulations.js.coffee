
$(document).ready ->
  $('#accordion').accordion();
  $('#field-settlement-population').keyup ->
    parsed = parseInt($(this).val());
    if (isNaN(parsed))
      $(this).val('');
    else
      $(this).val(parseInt($(this).val()));




