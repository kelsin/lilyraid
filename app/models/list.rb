class List < ActiveRecord::Base
    belongs_to :character
    belongs_to :raid

    has_many :list_positions, :dependent => :destroy, :order => :position
    has_one :loot

    def self.get_list(name)
        List.find(:first, 
                  :include => { :list_positions => { :character => :cclass } },
                  :conditions => ["lists.name = ? and date is null", name])
    end

    def to_s
        name
    end

    # Returns the live version of this list
    def newest
        List.find(:first, :conditions => ["date is null and name = ?", self.name])
    end

    # Helper function for console viewing :)
    def output
        self.list_positions.map do |lp|
            "#{lp.position}: #{lp.character}"
        end.join "\n"
    end            

    # Returns the list position with a character, or nil if one doesn't exist
    def find(character)
        self.list_positions.find(:first, :conditions => ["character_id = ?", character.id])
    end

    # Find all lists linked to this one, ordered by date
    def history
        List.find(:all, :conditions => ["date is not null and name = ?", self.name], :order => "date desc")
    end

    def raid_history(raid)
        List.find(:all, :conditions => ["date is not null and name = ? and raid_id = ?", self.name, raid.id],
                  :order => "date desc")
    end

    # Grab only the notes from the history (With dates)
    def notes
        self.history.map { |list| "#{list.date.to_s(:raid)}: #{list.note}" }
    end

    # Takes a character that got loot and a list of characters that were present
    def loot(raid, character, present, item_url, item_name, date)
        character_lp = find(character)

        # If this character is in the list, cycle them down.
        if character_lp
            position = character_lp.position

            self.list_positions.find(:all,
                                     :order => :position,
                                     :conditions => ["character_id in (?) and position > ?",
                                                     present.map { |char| char.id },
                                                     position]).each do |lp|
                temp = lp.position
                lp.position = position
                lp.save
                position = temp
            end

            # Now set the loot winner to the position of the last person that moved
            character_lp.position = position
            character_lp.save

            self.reload

            self.backup_loot(raid, character, item_url, item_name, date)
        end
    end

    def list_positions_in_raid(raid)
        if raid
            self.list_positions.find_all do |lp|
                raid.character_in_raid(lp.character)
            end
        else
            self.list_positions
        end
    end                

    def cclasses(raid)
        cclasses_ary = self.list_positions_in_raid(raid).map do |lp|
            lp.character.cclass.name
        end

        cclasses_ary.uniq.sort
    end

    # Adds character to end of list (don't do anything if character is already in list)
    def add_to_end(character, date)
        if !self.find(character)
            lp = ListPosition.new
            lp.list = self
            lp.character = character

            if self.list_positions.size == 0
                lp.position = 1
            else
                lp.position = self.list_positions.maximum("position") + 1
            end

            lp.save

            self.list_positions = ListPosition.find(:all, :conditions => ["list_id = ?", self.id])

            self.backup "Added #{character} to the end of #{self}", date
        end
    end

    # Copy this list and save a date and note with it
    def backup(note, date)
        backup_list = List.new
        backup_list.name = self.name
        backup_list.date = date
        backup_list.note = note
        backup_list.save

        self.list_positions.each do |lp|
            backup_lp = ListPosition.new
            backup_lp.list = backup_list
            backup_lp.character = lp.character
            backup_lp.position = lp.position
            backup_lp.save
        end

        return backup_list
    end

    def backup_loot(raid, character, item_url, item_name, date)
        backup_list = List.new
        backup_list.name = self.name
        backup_list.date = date
        backup_list.character = character
        backup_list.raid = raid
        backup_list.item_url = item_url
        backup_list.item_name = item_name
        backup_list.save

        self.list_positions.each do |lp|
            backup_lp = ListPosition.new
            backup_lp.list = backup_list
            backup_lp.character = lp.character
            backup_lp.position = lp.position
            backup_lp.save
        end

        return backup_list
    end
end
