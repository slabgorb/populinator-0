# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

Being = () ->
   $('.randcheck.being-name').click ->
    $.get '/being/random-name',
      {}
      (data) ->
        $('#person_name').val data[1]
        $('#person_gender').val data[0]
        $('#person_age').val data[2]
      'json'


$(document).ready ->
  being = new Being();
