class Character < ActiveRecord::Base
    belongs_to :account
    belongs_to :race
    belongs_to :cclass

    has_many :attunements, :dependent => :destroy
    has_many :instances, :through => :attunements, :order => "instances.name"

    has_many :signups, :dependent => :nullify
    has_many :raids, :through => :signups

    has_many :loots, :dependent => :nullify

    validates_inclusion_of(:level,
                           :in => 1..80,
                           :message => "Valid levels are 1 through 80")

    before_destroy :can_delete

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

    def name_with_account
        "#{name} (#{account.name})"
    end

    def can_delete
        raids.empty?
    end
end
