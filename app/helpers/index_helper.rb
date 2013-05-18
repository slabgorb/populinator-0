module IndexHelper
  def flat_button(img, link, options = { })
    background_color = options[:color] || 'rgba(255,255,255,0)'
    label = options[:label] || ''
    size = options[:size] || 60
    %Q|
        <div class='flat-button tip' rel='.tooltip' href='#{link}' title='#{label}' style='width:#{size}px; height:#{size}px; background-color:#{background_color};'>
          <a  href='#{link}'><img src='/assets/heraldry/#{size}/#{img}.png'/></a>
        </div>
      |.html_safe
  end
end
