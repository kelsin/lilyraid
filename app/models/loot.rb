class Loot < ActiveRecord::Base
    belongs_to :list
    belongs_to :character
    belongs_to :raid

    def self.from(raid)
        find(:all,
             :conditions => ["raid_id = ?", raid.id],
             :include => [:character, :raid],
             :order => "list_id")
    end
end
