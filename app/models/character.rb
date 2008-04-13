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
                           :in => 1..70,
                           :message => "Valid levels are 1 through 70")

    before_destroy :check_raids

    def attuned(instance)
        instances.member?(instance)
    end

    def instances=(instance_ids)
        instance_ids.each do |id|
            Attunement.new(:character => self,
                           :instance_id => id).save
        end
        reload
    end

    def keyed(instance)
        instances.member?(instance)
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

    private

    def check_raids
        raids.empty?
    end
end
