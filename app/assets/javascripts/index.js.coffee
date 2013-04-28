# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
  $nav_list = $('.well.sidebar-nav ul.nav.nav-list')
  $('.sidebar-link-switcher').click ->
    $nav_list.find('li').not('.nav-header').remove()
    $nav_list.append(element) for element in ($(element) for element in $(this).find('.sidelinks li'))
    $nav_list.find('li.nav-header').text($(this).find('h4').text())
