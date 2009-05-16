class Location < ActiveRecord::Base
  belongs_to :raid
  belongs_to :instance
  has_many :loots

  before_save :check_duplicates

  def name
    instance.name
  end

  private

  def check_duplicates
    not Raid.find(self.raid_id).instances.member?(self.instance)
  end

end
