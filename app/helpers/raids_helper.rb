module RaidsHelper
  def raid_icon(raid)
    if raid.guild.present?
      guild_icon(Guild.named(raid.guild))
    else
      "&nbsp;".html_safe
    end
  end
end
