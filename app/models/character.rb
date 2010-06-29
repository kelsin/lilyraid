class Character < ActiveRecord::Base
  belongs_to :account
  belongs_to :race
  belongs_to :cclass

  has_many :signups, :dependent => :nullify
  has_many :raids, :through => :signups

  has_many :loots, :dependent => :nullify
  has_many :logs, :dependent => :destroy

  validates_inclusion_of(:level,
                         :in => 1..80,
                         :message => "Valid levels are 1 through 80")

  validates_uniqueness_of :name
  validates_presence_of :name

  validates_presence_of :account

  before_destroy :can_delete?

  named_scope :active, { :conditions => { :inactive => false } }
  named_scope :inactive, { :conditions => { :inactive => true } }

  named_scope :seated_in, lambda { |raid| {
      :include => { :signups => :slot },
      :conditions => ["signups.raid_id = ? and slots.signup_id = signups.id", raid.id]
    }
  }

  named_scope :not_signed_up_for, lambda { |raid| {
      :conditions => ["not exists (select 1
                                     from signups
                                    where raid_id = ?
                                      and character_id = characters.id)", raid.id]
    }
  }

  named_scope :in_loot_list, {
    :include => { :account => :list_positions },
    :conditions => "list_positions.id is not null",
    :order => "list_positions.position"
  }

  named_scope :not_in_loot_list, {
    :conditions => ["not exists (select 1
                                   from list_positions lp
                                  where lp.account_id = characters.account_id
                                    and lp.list_id = ?)", List.first ? List.first.id : 0]
  }

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
end
