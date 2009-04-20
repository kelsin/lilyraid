class ListPosition < ActiveRecord::Base
  belongs_to :account
  belongs_to :list

  default_scope :order => "position"

  named_scope :in_raid, lambda { |raid| {
      :include => { :account => { :characters => :signups } },
      :conditions => ["signups.raid_id = ?", raid.id]
    }
  }

  named_scope :seated_in, lambda { |raid| {
      :include => { :account => { :characters => { :signups => :slot } } },
      :conditions => ["signups.raid_id = ? and slots.id is not null", raid.id]
    }
  }
end
