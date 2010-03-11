class RaiderTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :raid
  belongs_to :account

  named_scope :in_past, lambda { |time| { :include => :raid, :conditions => { 'raids.date' => (Time.now - time)..(Time.now - 6.hours) } } }

  named_scope :for_raid, lambda { |raid| { :conditions => { :raid_id => raid } } }
  named_scope :for_tag, lambda { |tag| { :conditions => { :tag_id => tag } } }
  named_scope :for_account, lambda { |account| { :conditions => { :account_id => account } } }

  def to_s
    self.tag.to_s
  end
end
