
$ ->
  $nav_list = $('.well.sidebar-nav ul.nav.nav-list')
  $('.sidebar-link-switcher').click ->
    $nav_list.find('li').not('.nav-header').remove()
    $nav_list.append(element) for element in ($(element) for element in $(this).find('.sidelinks li'))
    $nav_list.find('li.nav-header').text($(this).find('h4').text())

$ ->
  $('#language-submit').click ->
    $(this).closest('form').trigger 'submit'


$ ->
  $('.tip').tooltip(placement: 'bottom', )

