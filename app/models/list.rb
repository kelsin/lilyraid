class List < ActiveRecord::Base
  has_many :list_positions, :dependent => :destroy, :order => :position
  has_many :accounts, :through => :list_positions
  has_one :loot

  def to_s
    self.name
  end

  def self.get_list(name)
    List.includes({ :list_positions => { :account => { :characters => :cclass } } }).where('lists.name = ? and date is null', name).order('list_positions.position').first
  end

  def self.get_list_from_raid(name, raid)
    List.includes({ :list_positions => {
                      :account => {
                        :characters => [:cclass,
                                        { :signups => {
                                            :slot => :raid }}]}}}).
      where('lists.name = ? and lists.date is null and raids.id = ?', name, raid.id).
      order('list_positions.position').first
  end

  def cclasses
    list_positions.map do |lp|
      lp.account.characters[0].cclass
    end.uniq.sort
  end

  # Returns the live version of this list
  def newest
    List.where('date is null and name = ?', self.name).first
  end

  # Helper function for console viewing :)
  def output
    self.list_positions.map do |lp|
      "#{lp.position}: #{lp.character}"
    end.join "\n"
  end

  # Returns the list position with a character, or nil if one doesn't exist
  def find(account)
    self.list_positions.where('account_id = ?', account.id).first
  end

  # Find all lists linked to this one, ordered by date
  def history
    List.where('date is not null and name = ?', self.name).order('date desc')
  end

  def raid_history(raid)
    List.where('date is not null and name = ? and raid_id = ?', self.name, raid.id).order('date desc')
  end

  # Grab only the notes from the history (With dates)
  def notes
    self.history.map { |list| "#{list.date.to_s(:raid)}: #{list.note}" }
  end

  # Takes a character that got loot and a list of characters that were present
  def new_loot(raid, loot)
    account_lp = self.list_positions.for_account(loot.character.account).first
    slot = raid.signups.seated.includes(:slot).where(:character_id => loot.character).slot

    if account_lp
      position = account_lp.position

      self.list_positions.where('account_id in (?) and position > ?',
                                raid.slots.in_term(slot.team).includes(:signup => {:character => :account}).all.
                                map(&:signup).compact.map(&:character).map(&:account).map(&:id),
                                position).order('position').all.each do |lp|
        temp = lp.position
        lp.position = position
        lp.save
        position = temp
      end

      account_lp.position = position
      account_lp.save

      self.reload
    end
  end

  # Adds character to end of list (don't do anything if character is already in list)
  def add_to_end(account)
    if !self.find(account)
      lp = ListPosition.new
      lp.list = self
      lp.account = account

      if self.list_positions.size == 0
        lp.position = 1
      else
        lp.position = self.list_positions.maximum("position") + 1
      end

      lp.save

      self.list_positions = ListPosition.where('list_id = ?', self.id).all

      lp
    end
  end
end
