class Loot < ActiveRecord::Base
  belongs_to :list
  belongs_to :character

  belongs_to :location
  belongs_to :raid
  belongs_to :instance

  default_scope :order => "loots.created_at"

  def swap
    temp = self.item_name
    self.item_name = self.item_url
    self.item_url = temp
    self.save
  end
end
