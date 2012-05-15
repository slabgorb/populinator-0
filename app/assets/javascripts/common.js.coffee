$ = jQuery

debug = false

# jquery plugins

# stash away the value of a form element into the title attribute
# TODO: check to see if I can just use a made-up one
$.fn.stash = () ->
  console.log('stashing') if debug
  $(this).attr('title', $(this).val())
  $(this).addClass('disabled').attr('disabled','disabled');

# 'unstash' the value of a form element from the title attribute
$.fn.unstash = () ->
  console.log('unstashing') if debug
  $(this).val($(this).attr('title'))
  $(this).removeClass('disabled').removeAttr('disabled');

# page setup
$(document).ready ->
  # set up the buttons
  # $( "input:submit, .button").button()
  # set up any tabs
  $('#tabs').tabs();
