class Raid < ActiveRecord::Base
    belongs_to :account
    belongs_to :instance
    belongs_to :raid_template
    has_many(:slots,
             :dependent => :destroy,
             :include => [:signup, :role, :cclass],
             :order => "slots.id")
    has_many :signups, :dependent => :destroy
    has_many :characters, :through => :signups, :order => "characters.name"
    has_many :loots

    def display_name
        name.blank? ? instance.name : name
    end

    def started?
        Time.now > self.date
    end

    def confirmed_characters
        slots.map do |slot|
            if slot.signup
                slot.signup.character
            end
        end.compact
    end

    def accounts
        slots.map do |slot|
            if slot.signup
                slot.signup.character.account
            end
        end.compact
    end

    def character_in_raid(character)
        confirmed_characters.member?(character)
    end

    def waiting_list_by_account
        waiting_list.inject([]) do |list, signup|
            if list.empty?
                [[signup]]            
            elsif list.last.first.character.account_id == signup.character.account_id
                list.last << signup
                list
            else
                list << [signup]
            end
        end
    end
                
    def is_open
        slots.each do |slot|
            if !slot.closed
                return true
            end
        end
        
        return false
    end

    def signups_from(account)
        signups.select do |signup|
            signup.character.account == account
        end
    end

    def remove_character(char)
        # Delete the signup_slot_types and signup row
        signup = Signup.find(:first, :conditions => ["raid_id = ? and character_id = ?", id, char.id])
        
        if signup
            date = signup.date
            # Destroy signups, this opens the slots up as well
            Signup.destroy(signup.id)

            # Redo the raid if raid
            resignup(date) unless locked

            return true
        else
            return false
        end
    end

    def find_character(char)
        Slot.find(:first,
                  :include => :signup,
                  :conditions => ["slots.raid_id = ? and character_id = ?", id, char.id])
    end

    def resignup(date)
        signups = Signup.find(:all, :conditions => [ "date >= ?", date])
        
        # Delete all slots that are tied to signsup past this date
        signups.each do |signup|
            signup.clear_slots
        end
        
        # redo all signups that occur on or past this date
        signups.each do |signup|
            place_character(signup)
        end
    end
    
    def waiting_list
        accounts = slots.map { |slot| slot.signup }.compact.map { |signup| signup.character.account }

        signups.select do |signup|
            !accounts.member?(signup.character.account)
        end
    end

    def place_character(signup)
        Slot.find(:all, :conditions => [ "raid_id = ? AND signup_id IS NULL AND closed = ?", id, false ], :order => "cclass_id desc, slot_type_id desc").each do |slot|
            if slot.accept_char(signup)
                # This slow will accept this character
                slot.signup = signup
                slot.save
                break;
            end
        end
    end

    def add_waiting_list
        waiting_list.each do |signup|
            place_character(signup)
        end
    end

    def each_group
        slots.each_slice(5) do |group|
            yield group
        end
    end

    def can_be_deleted?
        loots.size == 0
    end

    def after_create        
        instance.max_number.times do |num|
            Slot.new(:raid => self).save
        end
    end

    def needed
        needed = {}

        slots.each do |slot|
            if !slot.signup and !slot.closed
                if needed[slot]
                    needed[slot] = needed[slot] + 1
                else
                    needed[slot] = 1
                end
            end
        end

        return needed.sort do |a, b|
            a[0] <=> b[0]
        end
    end

    def uid
        "raid_#{self.id}@raids.dota-guild.com"
    end

    def url
        "http://raids.dota-guild.com/raid/#{self.id}"
    end
end
