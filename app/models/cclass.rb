class Cclass
  NUMBER = 11

  WARRIOR = 1
  PALADIN = 2
  HUNTER = 3
  ROGUE = 4
  PRIEST = 5
  DEATH_KNIGHT = 6
  SHAMAN = 7
  MAGE = 8
  WARLOCK = 9
  MONK = 10
  DRUID = 11

  ROLES = {
    WARRIOR => Role.to_mask([Role::TANK, Role::DPS]),
    PALADIN => Role.to_mask([Role::TANK, Role::HEAL, Role::DPS]),
    HUNTER => Role.to_mask([Role::DPS]),
    ROGUE => Role.to_mask([Role::DPS]),
    PRIEST => Role.to_mask([Role::HEAL, Role::DPS]),
    DEATH_KNIGHT => Role.to_mask([Role::TANK, Role::DPS]),
    SHAMAN => Role.to_mask([Role::HEAL, Role::DPS]),
    MAGE => Role.to_mask([Role::DPS]),
    WARLOCK => Role.to_mask([Role::DPS]),
    MONK => Role.to_mask([Role::TANK, Role::HEAL, Role::DPS]),
    DRUID => Role.to_mask([Role::TANK, Role::HEAL, Role::DPS]) }

  def self.all
    [WARRIOR, PALADIN, HUNTER, ROGUE, PRIEST, DEATH_KNIGHT, SHAMAN, MAGE, WARLOCK, DRUID]
  end

  def self.all_mask
    self.to_mask(self.all)
  end

  def self.to_array(mask)
    (0...NUMBER).inject([]) do |cclasses, cclass|
      cclasses << cclass if (mask & (2**cclass) > 0)
      cclasses
    end
  end

  def self.to_mask(cclasses)
    cclasses.inject(0) do |num, cclass|
      num + (2**cclass)
    end
  end

  def self.role_mask_for(cclass)
    ROLES[cclass]
  end
end
