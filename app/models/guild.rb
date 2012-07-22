class Guild < ActiveRecord::Base
  @@guilds = nil

  validates :officer_rank, :numericality => { :only_integer => true }

  def self.cache
    self.load_cache if @@guilds.nil?

    @@guilds.values.sort
  end

  def self.named(name)
    self.load_cache if @@guilds.nil?

    @@guilds[name]
  end

  def self.add(guild)
    @@guilds[guild.name] = guild
  end

  def self.clear_cache
    @@guilds = nil
  end

  def self.load_cache
    @@guilds = Guild.all.inject({}) do |hash, g|
      hash[g.name] = g
      hash
    end
  end

  def to_s
    self.name
  end
    
  def icon_color
    read_attribute(:icon_color).try(:[], 2..7)
  end

  def icon_color_alpha
    read_attribute(:icon_color).try(:[], 0..1)
  end

  def border_color
    read_attribute(:border_color).try(:[], 2..7)
  end

  def border_color_alpha
    read_attribute(:border_color).try(:[], 0..1)
  end

  def background_color
    read_attribute(:background_color).try(:[], 2..7)
  end

  def background_color_alpha
    read_attribute(:background_color).try(:[], 0..1)
  end

  def <=>(other)
    self.name <=> other.name
  end

  def update_from_armory!(realm = self.realm, guild = self.name)
    data = API.guild(realm, guild, 'fields' => 'members')

    if data
      self.realm = realm
      self.name = data['name']

      emblem = data['emblem']
      self.icon = emblem['icon']
      self.border = emblem['border']
      self.icon_color = emblem['iconColor']
      self.border_color = emblem['borderColor']
      self.background_color = emblem['backgroundColor']
      self.save
    end

    # Load characters from this realm
    characters = Character.where(:guild => self.name, :realm => self.realm).all.inject({}) do |hash, c|
      hash[c.name] = c
      hash
    end

    changed = []

    # Todo, update ranks
    data['members'].each do |member|
      c = characters[member['character']['name']]

      if c
        c.cclass_id = member['character']['class']
        c.race_id = member['character']['race']
        c.level = member['character']['level']
        c.rank = member['rank']
        c.officer = c.rank <= self.officer_rank

        if c.changed?
          c.save
          changed << c
        end
      end
    end

    Account.clear_officer_cache

    changed.sort do |a,b|
      a.name <=> b.name
    end
  end
end
