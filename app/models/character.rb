class Character < ActiveRecord::Base
  belongs_to :account

  has_many :signups, :dependent => :nullify
  has_many :raids, :through => :signups

  has_many :loots, :dependent => :nullify
  has_many :logs, :dependent => :destroy

  validates_uniqueness_of :name
  validates_presence_of :name, :account, :race_id, :cclass_id

  before_destroy :can_delete?

  default_scope :order => 'level desc, name'

  scope :active, { :conditions => { :inactive => false } }
  scope :inactive, { :conditions => { :inactive => true } }

  scope :seated_in, lambda { |raid| {
      :include => { :signups => :slot },
      :conditions => ["signups.raid_id = ? and slots.signup_id = signups.id", raid.id] } }

  scope :not_signed_up_for, lambda { |raid| {
      :conditions => ["not exists (select 1
                                     from signups
                                    where raid_id = ?
                                      and character_id = characters.id)", raid.id] } }

  scope :in_loot_list, {
    :include => { :account => :list_positions },
    :conditions => "list_positions.id is not null",
    :order => "list_positions.position" }

  scope :not_in_loot_list, {
    :conditions => ["not exists (select 1
                                   from list_positions lp
                                  where lp.account_id = characters.account_id
                                    and lp.list_id = ?)", List.first ? List.first.id : 0] }

  @@sides = { 
    1 => 'alliance',
    2 => 'horde',
    3 => 'alliance',
    4 => 'alliance',
    5 => 'horde',
    6 => 'horde',
    7 => 'alliance',
    8 => 'horde',
    9 => 'horde',
    10 => 'horde',
    11 => 'alliance',
    22 => 'alliance' }
  @@sides.default = 'neutral'

  def <=>(other)
    [other.level, name] <=> [level, other.name]
  end

  def to_s
    self.name
  end

  def name_with_level
    "#{name} (#{level})"
  end

  def name_with_level_and_account
    "#{name} (#{level}-#{account.name})"
  end

  def name_with_account
    "#{name} (#{account.name})"
  end

  def can_delete?
    raids.empty?
  end

  def is_alliance?
    self.side == 'alliance'
  end

  def is_horde?
    self.side == 'horde'
  end

  def side
    @@sides[self.race_id].titlecase
  end

  def pretty_realm
    Realms.name(self.realm)
  end

  def update_from_armory!(realm = self.realm, character = self.name)
    data = API.character(realm, character, 'fields' => 'guild')

    if data
      self.realm = realm
      self.name = data['name']
      self.cclass_id = data['class']
      self.race_id = data['race']
      self.level = data['level']
      self.guild = data['guild'].try(:[], 'name')
      self.thumbnail = data['thumbnail']
      self.save
    end
  end

  def self.guilds
    Character.select('distinct guild').map(&:guild).compact
  end
end
