module GuildsHelper
  def icon_image_url(guild)
    "http://#{CONFIG[:region]}.battle.net/wow/static/images/guild/tabards/emblem_#{'%02d' % guild.icon}.png"
  end

  def guild_icon(guild)
    content_tag(:div,
                :class => 'guild_icon',
                :style => "border-color: ##{guild.border_color};") do
      content_tag(:div, '',
                  :class => 'background',
                  :style => "background-color: ##{guild.background_color};") +
      content_tag(:div, '',
                  :class => 'emblem',
                  :style => "background-color: ##{guild.icon_color}; #{mask_image(icon_image_url(guild))}")
    end
  end

  def mask_image(url)
    ['-webkit-', '-o-', '-moz-', ''].map do |pre|
      "#{pre}mask-box-image: url('#{url}');"
    end.join(' ')
  end
end
