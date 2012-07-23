module RaidsHelper
  def raid_icon(raid)
    if raid.guild.present?
      guild_icon(Guild.named(raid.guild))
    else
      "&nbsp;".html_safe
    end
  end

  def slots(raid)
    raid.slots.map do |slot|
      if @slot.signup
        "make_slot('#slot_#{slot.id}', '#{slot.accepts}');"
      end
    end.compact.join
  end
end
