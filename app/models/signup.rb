class Signup < ActiveRecord::Base
  belongs_to :raid
  belongs_to :character

  has_many :signup_roles, :dependent => :destroy
  has_many :roles, :through => :signup_roles

  has_one :slot, :dependent => :nullify

  default_scope :order => 'signups.created_at'

  named_scope :from_account, lambda { |account|
    { :include => :character,
      :conditions => ["characters.account_id = ?", account.id] }
  }

  named_scope :in_raid, lambda { |raid|
    { :conditions => ["signups.raid_id = ?", raid.id] }
  }

  named_scope :waiting_list, {
    :include => :slot,
    :conditions => "slots.id is null",
  }

  named_scope :seated, {
    :include => :slot,
    :conditions => "slots.id is not null"
  }

  named_scope :not_in_loot_list, {
    :include => :character,
    :conditions => ["not exists (select 1
                                   from list_positions lp
                                  where lp.account_id = characters.account_id
                                    and lp.list_id = ?)", List.first.id]
  }

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
    roles.each do |role|
      c.push(role.name.downcase)
    end
    c.push(character.cclass.name.downcase.sub(/ /, '_'))
  end    

  public

  def date
    created_at
  end

  def other_signups
    raid.signups_from(character.account) - [self]
  end

  def has_other_signups
    other_signups.size > 0
  end

  def in_raid_slot?
    !slot.blank?
  end

  def role_ids=(roles)
    @roles = roles
  end

  def after_create
    @roles.each do |role|
      SignupRole.new(:signup => self, :role => Role.find(role)).save
    end

    reload
  end
end
