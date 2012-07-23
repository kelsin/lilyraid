class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character

  has_one :slot, :dependent => :nullify

  default_scope :order => 'signups.created_at'

  scope :from_account, lambda { |account| {
      :include => :character,
      :conditions => { 'characters.account_id' => account } } }

  scope :past, :include => :raid, :conditions => ['raids.date < ?', Date.today]
  scope :last_month, :include => :raid, :conditions => ['raids.date >= ?', Date.today - 1.month]
  scope :last_three_months, :include => :raid, :conditions => ['raids.date >= ?', Date.today - 3.months]

  scope :in_raid, lambda { |raid| {
      :conditions => ["signups.raid_id = ?", raid.id] } }

  scope :waiting_list, {
    :include => :slot,
    :conditions => "slots.id is null" }

  scope :seated, {
    :include => :slot,
    :conditions => "slots.id is not null" }

  scope :not_in_loot_list, {
    :include => :character,
    :conditions => ["not exists (select 1
                                   from list_positions lp
                                  where lp.account_id = characters.account_id
                                    and lp.list_id = ?)", List.first ? List.first.id : 0] }

  before_save :remove_default_note

  def to_s
    self.character.to_s
  end

  def classes(others = true)
    c = Array.new
    c.push("signup")
    c.push("account_#{character.account.id}")
    c = c + classes_array

    ([self] + other_signups).each do |signup|
      if signup.slot
        c.push("seated")
        break
      end
    end

    c = c + other_signups.map(&:classes_array) if others

    c.uniq.join(" ")
  end

  protected

  def classes_array
    c = Array.new
    c.push("character_#{character.id}")
    c.push("class_#{character.class}")
  end

  public

  def raider_tags
    self.character.account.raider_tags.for_raid(self.raid)
  end

  def tags
    self.raider_tags.map(&:tag)
  end

  def date
    created_at
  end

  def account
    self.character.account if self.character
  end

  def other_signups
    raid.signups_from(character.account) - [self]
  end

  def has_other_signups?
    other_signups.size > 0
  end

  def in_raid_slot?
    !slot.blank?
  end

  def role_ids=(roles)
    @roles = roles
  end

  def remove_default_note
    if self.note == "Note"
      self.note = ""
    end
  end

  def after_create
    @roles.each do |role|
      SignupRole.new(:signup => self, :role => Role.find(role)).save
    end

    reload
  end
end
