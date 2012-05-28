
debug = false

class Person
  constructor: ->
    $('.randcheck.being-name').click ->
     $.get '/people/random-name',
       (data) ->
         console.log data
         $('#person_name').val data[1]
           .reverse()
           .join(' ')
         $('#person_gender_input').val data[0]
         $('#person_age').val data[2]
       'json'

$ ->
  window.person = new Person
