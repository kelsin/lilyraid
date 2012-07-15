class RaiderTag < ActiveRecord::Base
  belongs_to :tag
  belongs_to :raid
  belongs_to :account

  scope :in_past, lambda { |time| { :include => :raid, :conditions => { 'raids.date' => (Time.now - time)..(Time.now - 6.hours) } } }

  scope :for_raid, lambda { |raid| { :conditions => { :raid_id => raid } } }
  scope :for_tag, lambda { |tag| { :conditions => { :tag_id => tag } } }
  scope :for_account, lambda { |account| { :conditions => { :account_id => account } } }

  def to_s
    self.tag.to_s
  end
end
