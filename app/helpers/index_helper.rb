module IndexHelper
  def flat_button(img, link, options = { })
    background_color = options[:color] || 'rgba(255,255,255,0)'
    label = options[:label] || ''
    size = options[:size] || 60
    %Q|
        <div class='flat-button' rel='#{link}' style='background-color:#{background_color};'>
          <a  href='#{link}'><div class='flat-button-label'>#{label}<div></a>
          <a  href='#{link}'><img src='/assets/heraldry/#{size}/#{img}.png'/></a>
        </div>
      |.html_safe
  end
end
