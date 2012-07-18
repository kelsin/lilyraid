module CharactersHelper
  def character_link(character)
    link_to character.name, "http://#{CONFIG[:region]}.battle.net/wow/character/#{URI.escape(CONFIG[:realm])}/#{URI.escape(character.name)}/simple"
  end

  def guild_link(character)
    if character.guild.present?
      link_to character.guild, "http://#{CONFIG[:region]}.battle.net/wow/guild/#{URI.escape(CONFIG[:realm])}/#{URI.escape(character.guild)}/?character=#{URI.escape(character.name)}"
    end
  end

  def character_image_url(character)
    "http://#{CONFIG[:region]}.battle.net/static-render/#{CONFIG[:region]}/#{character.thumbnail}"
  end
end
