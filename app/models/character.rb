class Character < ActiveRecord::Base
  belongs_to :account

  has_many :signups, :dependent => :nullify
  has_many :raids, :through => :signups

  has_many :loots, :dependent => :nullify
  has_many :logs, :dependent => :destroy

  validates_uniqueness_of :name
  validates_presence_of :name, :account, :race_id, :cclass_id

  before_destroy :can_delete?

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

  def update_from_armory!(character = self.name)
    data = API.character(CONFIG[:realm], character, 'fields' => 'guild')

    if data
      self.name = data['name']
      self.cclass_id = data['class']
      self.race_id = data['race']
      self.level = data['level']
      self.guild = data['guild'].try(:[], 'name')
      self.thumbnail = data['thumbnail']
      self.save
    end
  end
end
