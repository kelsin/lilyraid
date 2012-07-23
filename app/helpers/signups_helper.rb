module SignupsHelper
  def signup_classes(signup)
    Role.to_array(signup.roles).map do |role|
      "role_#{role}"
    end + [('seated' if signup.in_raid_slot? and signup.raid.finalized?),
           ('preferred' if signup.preferred?)].compact
  end
end
