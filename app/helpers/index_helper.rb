module IndexHelper
  def flat_button(img, link, color='#FF0000', label='')
    %Q|
       <div class='icon' rel='#{link}' style='background-color:#{color};'>
          <a  href='#{link}'>#{label}</a>
          <a  href='#{link}'><img src='/assets/icons/#{img}.png'/></a></div>|.html_safe
  end
end
