class Character < ActiveRecord::Base
  belongs_to :account
  belongs_to :race
  belongs_to :cclass

  has_many :signups, :dependent => :nullify
  has_many :raids, :through => :signups

  has_many :loots, :dependent => :nullify

  validates_inclusion_of(:level,
                         :in => 1..80,
                         :message => "Valid levels are 1 through 80")

  before_destroy :can_delete

  named_scope :active, { :conditions => { :inactive => false } }
  named_scope :inactive, { :conditions => { :inactive => true } }

  named_scope :seated_in, lambda { |raid| {
      :include => { :signups => :slot },
      :conditions => ["signups.raid_id = ? and slots.signup_id = signups.id", raid.id]
    }
  }

  named_scope :in_raid, lambda { |raid| {
      :include => :signups,
      :conditions => ["signups.raid_id = ?", raid.id]
    }
  }

  named_scope :not_in_raid, lambda { |raid| {
      :conditions => ["not exists (select 1
                                     from signups
                                    where raid_id = ?
                                      and character_id = characters.id)", raid.id],
      :order => "level desc, name"
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
                                    and lp.list_id = ?)", List.first.id]
  }

  def attuned(instance)
    instances.member?(instance)
  end

  def instances=(instance_ids)
    Attunement.destroy_all(["character_id = ?", self.id])
    instance_ids.each do |id|
      Attunement.new(:character => self,
                     :instance_id => id).save
    end
    reload
  end

  def keyed(instance)
    instances.member?(instance)
  end

  def self.can_join(raid)
    if raid.instance.requires_key
      find(:all,
           :order => "characters.name",
           :include => :instances,

           :conditions => ["instances.id = ? and characters.level >= ? and characters.level <= ? and characters.inactive = ?", raid.instance.id, raid.min_level, raid.max_level, false]) - raid.characters
    else
      find(:all,
           :order => "characters.name",
           :include => :instances,
           :conditions => ["characters.level >= ? and characters.level <= ? and characters.inactive = ?", raid.min_level, raid.max_level, false]) - raid.characters
    end
  end

  def can_join(raid)
    if level < raid.min_level or level > raid.max_level
      false
    elsif raid.instance.requires_key and !keyed(raid.instance)
      false
    else
      true unless raids.member?(raid)
    end
  end

  def name_with_level
    "#{name} (#{level})"
  end

  def name_with_account
    "#{name} (#{account.name if account})"
  end

  def can_delete
    raids.empty?
  end
end
