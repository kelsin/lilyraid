class Realms
  # Cache of realms
  @@realms = nil

  def self.name(slug)
    self.all[slug]
  end

  def self.all
    @@realms ||= API.realm["realms"].inject({}) do |hash, data|
      hash[data["slug"]] = data["name"]
      hash
    end
  rescue
    # Return an empty list... get the realms next time
    {}
  end
end
